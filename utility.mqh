#property copyright "No, copyright, Daniel Mooney"
#property version   "1.0"
#property library
#property strict

#property description "General utility functions."

#ifndef UTILITY_MQH
#define UTILITY_MQH

#define _NO_ORDER_FOUND_ -1

#include <Arrays/List.mqh>
#include <Arrays/ArrayObj.mqh>

// ---------------------- Declarations ----------------------

/**
 * @brief Frees the memory allocated for the given array.
 * 
 * @param array 
 */
void freeArrayObj(CArray* array);

/**
 * @brief Frees the memory allocated for the given list.
 * 
 * @param list 
 */
void freeList(CList* list);

/**
 * @brief Checks whether the provided symbol has
 * an order open on it.
 * 
 * @param symbol 
 * @return int The ticket of the first open order or
 * -1 if there is no order
 */
int symbolHasOrder(string symbol);


// ---------------------- Definitions ----------------------
void freeArrayObj(CArrayObj* array) {
    if (array == NULL) {
        return;
    }

    array.Shutdown();
    delete array;

    return;
}

void freeList(CList* list) {
    if (list == NULL) {
        return;
    }

    list.Clear();
    delete list;

    return;
}

// ----------
int symbolHasOrder(string symbol) {
    int total = OrdersTotal();

    for (int i = 0; i < total; i++) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol) return OrderTicket();
        }
    }

    return _NO_ORDER_FOUND_;
}

#endif