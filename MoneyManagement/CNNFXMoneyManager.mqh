#property copyright "No copyright, Daniel Mooney"
#property version   "1.0"
#property library
#property strict

#ifndef NNF_MONEYMANAGEMENT_MQH
#define NNF_MONEYMANAGEMENT_MQH

#include <MQL4Library/MoneyManagement/CAtrMoneyManager.mqh>
#include <MQL4Library/DataStructures/ObjectLinkedList.mqh>
#include <MQL4Library/DataStructures/ObjectNode.mqh>
#include <MQL4Library/DataStructures/LinkedList.mqh>
#include <MQL4Library/DataStructures/Node.mqh>
#include <MQL4Library/Order/CNNFXOrderPair.mqh>
#include <MQL4Library/Order/COrderPool.mqh>
#include <MQL4Library/Order/COrder.mqh>

class CNNFXMoneyManager: public CAtrMoneyManager {
    public:
        /**
         * @brief Construct a new CNNFXMoneyManager object
         * 
         * @param order_pool NULL if you don't want to use the order pool.
         * @param max_risk Maximum risk per trade in percentage of account balance.
         * @param stoploss_multiplier Multiple of ATR to use for stoploss.
         * @param takeprofit_multiplier Multiple of ATR to use for takeprofit.
         * @param atr_period 
         * @param atr_shift 
         */
        CNNFXMoneyManager(
            COrderPool* order_pool,
            double max_risk,
            double stoploss_multiplier,
            double takeprofit_multiplier,
            double trailing_stoploss_multiplier,
            int atr_period = 14,
            int atr_shift = 0
        );

        /**
         * @brief Determines the parameters for an order
         * in the style of No nonsense forex.
         * 
         * @param symbol 
         * @param timeframe 
         * @param order_type 
         * @param stoploss 
         * @param takeprofit 
         * @param lots_1 The lots for the TP order
         * @param lots_2 The lots for the runner order
         */
        void calculateOrderParameters(
            string symbol,
            ENUM_TIMEFRAMES timeframe,
            ENUM_OrderType order_type,
            double& price,
            double& stoploss,
            double& takeprofit,
            double& lots_1,
            double& lots_2
        );

        /**
         * @brief Adds a NNFX order that can be tracked
         * by the MoneyManager.
         * 
         * @param take_profit_ticket 
         * @param runner_ticket 
         */
        void addNNFXOrder(
            int take_profit_ticket,
            int runner_ticket
        );
        
        /**
         * @brief Manage orders in the NNFX style
         * 
         */
        void manageOrders();

        /**
         * @brief Removes orders that no longer exist
         * from the LinkedLists
         * 
         */
        void removeStaleOrders();

        /**
         * @brief Take profit event callback
         * 
         * @param order 
         */
        void takeProfitCallback(const COrder& order) override;

        /**
         * @brief Stop loss event callback
         * 
         * @param order 
         */
        void stopLossCallback(const COrder& order) override;
    
    private:
        double trailing_stoploss_multiplier_;
        ObjectLinkedList<CNNFXOrderPair> order_pairs_;

        // Tickets of orders that have had their take profit hit
        LinkedList<int> take_profit_tickets_;
};

// ---------------------- Implementation ----------------------

CNNFXMoneyManager::CNNFXMoneyManager(
    COrderPool* order_pool,
    double max_risk,
    double stoploss_multiplier,
    double takeprofit_multiplier,
    double trailing_stoploss_multiplier,
    int atr_period,
    int atr_shift
)   : CAtrMoneyManager(
        order_pool,
        max_risk,
        stoploss_multiplier,
        takeprofit_multiplier,
        atr_period,
        atr_shift
    )
    , trailing_stoploss_multiplier_(trailing_stoploss_multiplier)
{}

// ----------
void CNNFXMoneyManager::calculateOrderParameters(
    string symbol,
    ENUM_TIMEFRAMES timeframe,
    ENUM_OrderType order_type,
    double& price,
    double& stoploss,
    double& takeprofit,
    double& lots_1,
    double& lots_2
) {
    // Todo: Change risk based on exposure to other symbols
    // if (order_pool_ != NULL) {

    // }

    double total_lots = 0.0;
    CAtrMoneyManager::calculateOrderParameters(
        symbol,
        timeframe,
        order_type,
        price,
        stoploss,
        takeprofit,
        total_lots
    );

    total_lots *= 100;

    lots_1 = MathCeil(total_lots / 2.0) / 100.0;
    lots_2 = MathFloor(total_lots / 2.0) / 100.0;

    return;
}

// ----------
void CNNFXMoneyManager::addNNFXOrder(
    int take_profit_ticket,
    int runner_ticket
) {
    CNNFXOrderPair order_pair(
        take_profit_ticket,
        runner_ticket
    );

    order_pairs_.push_back(order_pair);
    return;
}

// ----------
void CNNFXMoneyManager::manageOrders() {
    // Modify trailing stop if necessary
    removeStaleOrders();

    Node<int>* take_profit_node = take_profit_tickets_.head();

    while (take_profit_node != NULL) {
        int ticket = take_profit_node.data();
        COrder* order = order_pool_.getOrder(ticket);
        
        // Get median price
        double symbol_ask = SymbolInfoDouble(
            order.getSymbol(),
            SYMBOL_ASK
        );

        double symbol_bid = SymbolInfoDouble(
            order.getSymbol(),
            SYMBOL_BID
        );

        double median_price = (symbol_ask + symbol_bid) / 2.0;

        // Find trailing stoploss price
        // TODO: store timeframe in order

        double atr = iATR(
            order.getSymbol(),
            PERIOD_CURRENT,
            atr_period_,
            atr_shift_
        );

        double trailing_stop;

        if (order.getType() == OT_BUY) {
            trailing_stop = median_price - (atr * trailing_stoploss_multiplier_);

            if (trailing_stop > order.getStopLoss()) {
                order.setStoploss(trailing_stop);
            }
        } else {
            trailing_stop = median_price + (atr * trailing_stoploss_multiplier_);

            if (trailing_stop < order.getStopLoss()) {
                order.setStoploss(trailing_stop);
            }
        }

        return;
    }
}

// ----------
void CNNFXMoneyManager::removeStaleOrders() {
    // Remove stale orders from order pair list
    ObjectNode<CNNFXOrderPair>* curr = order_pairs_.head();
    int i = 0;

    while (curr != NULL) {
        CNNFXOrderPair* order_pair = curr.data();
        curr = curr.next();

        if (!order_pool_.contains(order_pair.runnerTicket())) {
            order_pairs_.remove(i);
            continue;
        }

        i++;
    }

    // Remove stale orders from take profit ticket list
    Node<int>* take_profit_node = take_profit_tickets_.head();
    i = 0;

    while (take_profit_node != NULL) {
        int ticket = take_profit_node.data();
        take_profit_node = take_profit_node.next();

        if (!order_pool_.contains(ticket)) {
            take_profit_tickets_.remove(i);
            continue;
        }

        i++;
    }

    return;
}

// ----------
void CNNFXMoneyManager::takeProfitCallback(const COrder& order) {
    // Find matching runner order
    int ticket = order.getTicket();
    int runner_ticket = -1;

    ObjectNode<CNNFXOrderPair>* curr = order_pairs_.head();

    while (curr != NULL) {
        CNNFXOrderPair* order_pair = curr.data();

        if (order_pair.takeProfitTicket() == ticket) {
            runner_ticket = order_pair.runnerTicket();

            take_profit_tickets_.push_back(
                runner_ticket
            );
            order_pair.takeProfit();
            
            break;
        }

        curr = curr.next();
    }

    // Modify stoploss of runner orders
    if (runner_ticket != -1) {
        COrder* runner_order = order_pool_.getOrder(runner_ticket);
        runner_order.setStoploss(order.getOrderPrice());
    }

    return;
}

// ----------
void CNNFXMoneyManager::stopLossCallback(const COrder& order) {
    // Remove order from lists
    int ticket = order.getTicket();
    ObjectNode<CNNFXOrderPair>* curr = order_pairs_.head();
    int i = 0;

    // Order pair list
    while (curr != NULL) {
        CNNFXOrderPair* order_pair = curr.data();

        if (order_pair.runnerTicket() == ticket) {
            order_pairs_.remove(i);
            break;
        }

        curr = curr.next();
        i++;
    }

    // Take profit ticket list
    Node<int>* take_profit_node = take_profit_tickets_.head();

    while (take_profit_node != NULL) {
        if (take_profit_node.data() == ticket) {
            take_profit_tickets_.remove(i);
            break;
        }

        take_profit_node = take_profit_node.next();
        i++;
    }

    return;
}

#endif