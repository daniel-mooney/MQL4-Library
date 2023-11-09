#property copyright "No copyright, Daniel Mooney"
#property version   "1.0"
#property library

/** TODO
 *  - Store timeframe the order is placed in.
 * 
 */

#ifndef ORDER_MQH
#define ORDER_MQH

#include <Object.mqh>

#define _ORDER_DNE -1       // Order does not exist

// ---------------------- Declarations ----------------------

enum ENUM_OrderType {
    OT_BUY = OP_BUY,
    OT_SELL = OP_SELL,
    OT_NONE
};

enum ENUM_CloseType {
    CT_OPEN,           // Order is still open i.e. not closed
    CT_STOPLOSS,
    CT_TAKEPROFIT,
    CT_TRAILINGSTOP,
    CT_OTHER,
    CT_NONE
};

/**
 * @brief Converts OP codes (i.e. OP_BUY) to
 * ENUM_OrderType (i.e. OT_BUY)
 * 
 * @param op 
 * @return ENUM_OrderType 
 */
ENUM_OrderType OPCodeToOrderType(int op) export;   


/**
 * @brief Information about a trade
 * 
 */
class COrder: public CObject {
    public:
        /**
         * @brief Creates a new COrder object.
         * 
         * @param ticket 
         * @param symbol 
         * @param type 
         * @param lots 
         * @param order_price 
         * @param stoploss 
         * @param takeprofit 
         */
        COrder(
            int ticket,
            string symbol,
            datetime open_time,
            ENUM_OrderType type,
            double lots,
            double order_price,
            double stoploss,
            double takeprofit
        );

        /**
         * @brief Copy constructor
         * 
         * @param order 
         */
        COrder(const COrder& order);

        /**
         * @brief Checks if the order is closed.
         * 
         * @return bool True if the order is closed.
         */
        bool isClosed() const;

        /**
         * @brief Closes the order
         * 
         */
        void close();

        /**
         * @brief Gets the index of the order
         * 
         * @return int The index of the order or -1 if not found.
         */
        int getIndex(
            int pool = MODE_TRADES
        ) const;

        /**
         * @brief Gets the way the order was closed.
         * 
         * @return ENUM_CloseType If the order is still open, 
         * returns ENUM_CloseType::OPEN.
         */
        ENUM_CloseType getCloseType(
            int slippage = 10
        ) const;

        int getTicket() const;
        string getSymbol() const;
        datetime getOpenTime() const;
        ENUM_OrderType getType() const;
        double getLots() const;
        double getOrderPrice() const;
        double getStopLoss() const;
        double getTakeProfit() const;

        /**
         * @brief Sets the stoploss of the order.
         * 
         * @param stoploss The new stoploss level.
         */
        void setStoploss(double stoploss);

        /**
         * @brief Sets the takeprofit of the order.
         * 
         * @param takeprofit The new takeprofit level.
         */
        void setTakeprofit(double takeprofit);

        /**
         * @brief Comparison operator
         * 
         * @param rhs 
         * @return bool
         */
        bool operator==(const COrder& rhs) const;

    private:
        int ticket_;
        string symbol_;
        datetime open_time_;
        ENUM_OrderType type_;
        double lots_;
        double order_price_;
        double stoploss_;
        double init_stoploss_;
        double takeprofit_;
};

ENUM_OrderType OPCodeToOrderType(int op) export {
    switch (op) {
        case OP_BUY:
            return ENUM_OrderType::OT_BUY;
        case OP_SELL:
            return ENUM_OrderType::OT_SELL;
        default:
            return ENUM_OrderType::OT_NONE;
    }
}

// ---------------------- COrder Definitions ----------------------
COrder::COrder(
    int ticket,
    string symbol,
    datetime open_time,
    ENUM_OrderType type,
    double lots,
    double order_price,
    double stoploss,
    double takeprofit
)   : ticket_(ticket)
    , symbol_(symbol)
    , open_time_(open_time)
    , type_((ENUM_OrderType) type)
    , lots_(lots)
    , order_price_(order_price)
    , stoploss_(stoploss)
    , init_stoploss_(stoploss)
    , takeprofit_(takeprofit)
{}

// ----------
COrder::COrder(const COrder& order) {
    ticket_ = order.ticket_;
    symbol_ = order.symbol_;
    type_ = order.type_;
    lots_ = order.lots_;
    order_price_ = order.order_price_;
    stoploss_ = order.stoploss_;
    takeprofit_ = order.takeprofit_;
}

// ----------
int COrder::getIndex(
    int pool
) const {
    for (int i = 0; i < OrdersTotal(); i++) {
        if (OrderSelect(i, SELECT_BY_POS, pool)) {
            if (OrderTicket() == ticket_) {
                return i;
            }
        }
    }

    return _ORDER_DNE;
}

// ----------
bool COrder::isClosed() const {
    if (!OrderSelect(ticket_, SELECT_BY_TICKET, MODE_TRADES)) {
        Print("Failed to select order: " + IntegerToString(GetLastError()));
        return true;
    }

    return OrderCloseTime() != 0;
}

// ----------
void COrder::close() {
    bool success = OrderClose(
        ticket_,
        lots_,
        OrderClosePrice(),
        10
    );

    if (!success) {
        Print("Failed to close order: " + IntegerToString(GetLastError()));
        return;
    }

    return;
}

// ----------
ENUM_CloseType COrder::getCloseType(int slippage) const {
    if (getIndex() != _ORDER_DNE) {
        return ENUM_CloseType::CT_OPEN;
    }

    bool success = OrderSelect(
        ticket_,
        SELECT_BY_TICKET,
        MODE_HISTORY
    );

    if (!success) {
        Print("Failed to select order: " + IntegerToString(GetLastError()));
        return ENUM_CloseType::CT_NONE;
    }

    double delta_stoploss = OrderClosePrice() - OrderStopLoss();

    if (MathAbs(delta_stoploss) < slippage * Point) {
        // init_stoploss_ somehow being zero
        // if (stoploss_ != init_stoploss_) {
        //     Print("Stoploss: " + DoubleToString(stoploss_) + " Init: " + DoubleToString(init_stoploss_));
        //     return ENUM_CloseType::CT_TRAILINGSTOP;
        // }
        return ENUM_CloseType::CT_STOPLOSS;
    }

    double delta_takeprofit = OrderClosePrice() - OrderTakeProfit();

    if (MathAbs(delta_takeprofit) < slippage * Point) {
        return ENUM_CloseType::CT_TAKEPROFIT;
    }

    return ENUM_CloseType::CT_OTHER;
}

// ----------
int COrder::getTicket() const {
    return ticket_;
}

// ----------
string COrder::getSymbol() const {
    return symbol_;
}

// ----------
datetime COrder::getOpenTime() const {
    return open_time_;
}

// ----------
ENUM_OrderType COrder::getType() const {
    return type_;
}

// ----------
double COrder::getLots() const {
    return lots_;
}

// ----------
double COrder::getOrderPrice() const {
    return order_price_;
}

// ----------
double COrder::getStopLoss() const {
    return stoploss_;
}

// ----------
double COrder::getTakeProfit() const {
    return takeprofit_;
}

// ----------
void COrder::setStoploss(double stoploss) {
    
    bool success = OrderModify(
        ticket_,
        order_price_,
        stoploss,
        takeprofit_,
        0,
        CLR_NONE
    );

    if (!success) {
        Print("Failed to modify stoploss: " + IntegerToString(GetLastError()));
        return;
    }

    stoploss_ = stoploss;
    return;
}

// ----------
void COrder::setTakeprofit(double takeprofit) {
    
    bool success = OrderModify(
        ticket_,
        order_price_,
        stoploss_,
        takeprofit,
        0,
        CLR_NONE
    );

    if (!success) {
        Print("Failed to modify takeprofit: " + IntegerToString(GetLastError()));
        return;
    }

    takeprofit_ = takeprofit;
    return;
}

// ----------
bool COrder::operator==(const COrder& rhs) const {
    bool same_ticket = ticket_ == rhs.ticket_;
    bool same_symbol = symbol_ == rhs.symbol_;
    bool same_type = type_ == rhs.type_;
    bool same_lots = lots_ == rhs.lots_;
    bool same_order_price = order_price_ == rhs.order_price_;
    bool same_stoploss = stoploss_ == rhs.stoploss_;
    bool same_takeprofit = takeprofit_ == rhs.takeprofit_;

    return (
        same_ticket
        && same_symbol
        && same_type
        && same_lots
        && same_order_price
        && same_stoploss
        && same_takeprofit
    );
}

#endif