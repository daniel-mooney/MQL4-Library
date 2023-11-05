#property copyright "No, copyright, Daniel Mooney"
#property version   "1.0"
#property library
// #property strict

#ifndef C_ORDER_POOL_MQH
#define C_ORDER_POOL_MQH

#include <Arrays/List.mqh>
#include <Arrays/ArrayObj.mqh>
#include <MQL4Library/Order/COrder.mqh>

/**
 * @brief Keeps track of orders in the order pool
 * 
 */
class COrderPool {
    public:
        /**
         * @brief Constructs a new Order pool
         * @details Orders are dynamically allocated
         * and owned by the order pool.
         * 
         */
        COrderPool();
        
        /**
         * @brief Destroys the COrderPool object
         * @details Frees all memory allocated for orders.
         * 
         */
        ~COrderPool();

        /**
         * @brief Adds an order to the order pool
         * @details The order pool takes ownership of the order.
         * 
         * @param order The order to add.
         */
        void addOrder(
            int ticket,
            string symbol,
            int type,
            double lots,
            double open_price,
            double stop_loss,
            double take_profit
        );

        /**
         * @brief Removes an order from the order pool
         * 
         * @param ticket The ticket of the order to remove.
         * @return bool True if the order was removed, false otherwise.
         */
        bool removeOrder(int ticket);

        /**
         * @brief Gets the order with the given ticket.
         * 
         * @param ticket The ticket of the order to get.
         * @return COrder* The order with the given ticket or nullptr if not found.
         */
        COrder* getOrder(int ticket);

        /**
         * @brief Returns an array of orders in the order pool.
         * @note The array is dynamically allocated and must be freed.
         * 
         * @return CArrayObj* 
         */
        CArrayObj* Orders();

        /**
         * @brief Checks if the order pool contains an order with the given ticket.
         * 
         * @param ticket 
         * @return bool
         */
        bool contains(int ticket);

        /**
         * @brief Gets the number of orders in the order pool.
         * 
         * @return int The number of orders in the order pool.
         */
        int size();

        /**
         * @brief Removes all orders that have been closed.
         * 
         * @return int The number of orders removed.
         */
        int removeStaleOrders();

    private:
        CList* orders_;
};

// ---------- Definitions ----------

COrderPool::COrderPool() {
    orders_ = new CList();
    orders_.FreeMode(true);
}

// ----------
COrderPool::~COrderPool() {
    orders_.Clear();
    delete orders_;
}

// ----------
void COrderPool::addOrder(
    int ticket,
    string symbol,
    int type,
    double lots,
    double open_price,
    double stop_loss,
    double take_profit
) {
    // Two orders cannot have the same ticket
    if (contains(ticket)) {
        string error_msg = "[COrderPool::addOrder] -> "
            +"Order with ticket " 
            + IntegerToString(ticket) 
            + " already exists.";
        
        Print(error_msg);
        return;
    }

    COrder* order = new COrder(
        ticket,
        symbol,
        type,
        lots,
        open_price,
        stop_loss,
        take_profit
    );

    orders_.Add(order);
}

// ----------
bool COrderPool::removeOrder(int ticket) {
    COrder* order = orders_.GetFirstNode();

    while (order != NULL) {
        if (order.getTicket() == ticket) {
            orders_.DeleteCurrent();
            return true;
        }

        order = orders_.GetNextNode();
    }

    return false;
}

// ----------
COrder* COrderPool::getOrder(int ticket) {
    COrder* order = orders_.GetFirstNode();

    while (order != NULL) {
        if (order.getTicket() == ticket) {
            return order;
        }

        order = orders_.GetNextNode();
    }

    return NULL;
}

// ----------
CArrayObj* COrderPool::Orders() {
    CArrayObj* orders_array = new CArrayObj();
    COrder* order = orders_.GetFirstNode();

    orders_array.FreeMode(true);

    while (order != NULL) {
        orders_array.Add(new COrder(*order));
        order = orders_.GetNextNode();
    }

    return orders_array;
}

// ----------
bool COrderPool::contains(int ticket) {
    COrder* order = orders_.GetFirstNode();

    while (order != NULL) {
        if (order.getTicket() == ticket) {
            return true;
        }

        order = orders_.GetNextNode();
    }

    return false;
}

// ----------
int COrderPool::size() {
    return orders_.Total();
}

// ----------
int COrderPool::removeStaleOrders() {
    int num_removed = 0;
    COrder* order = orders_.GetFirstNode();

    while (order != NULL) {
        if (order.isClosed()) {
            orders_.DeleteCurrent();
            num_removed++;
        }

        order = orders_.GetNextNode();
    }

    return num_removed;
}

#endif