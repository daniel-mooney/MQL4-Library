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

/**
 * @brief Draws an arrow on the trading chart
 * 
 * @param id The id of the arrow
 * @param colour The colour of the arrow
 * @param direction The direction of the arrow
 * @return bool True if the arrow was drawn, false otherwise.
 */
bool drawChartArrow(
    string id,
    color colour,
    int direction,
    int offset = 0
);


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

// ----------
bool drawChartArrow(
    string id,
    color colour,
    int direction,
    int offset
) {
    if (direction != SYMBOL_ARROWUP && direction != SYMBOL_ARROWDOWN) {
        Print("drawChartArrow(): Invalid direction");
        return false;
    }

    // Use atr to offset arrow from price
    double atr = iATR(
        Symbol(),
        PERIOD_CURRENT,
        14,
        offset
    );
    const double atr_multiplier = 0.75;

    double anchor_price = 0.0;
    
    if (direction == SYMBOL_ARROWUP) {
        anchor_price = Low[offset] - atr * atr_multiplier;
    } else {
        anchor_price = High[offset] + 2 * atr * atr_multiplier;
    }


    const int arrow_height = 7;


    bool success = ObjectCreate(
        id,
        OBJ_ARROW,
        0,
        Time[offset],
        anchor_price
    );

    ObjectSet(id, OBJPROP_ARROWCODE, direction);
    ObjectSet(id, OBJPROP_COLOR, colour);
    ObjectSet(id, OBJPROP_WIDTH, arrow_height);
    ObjectSet(id, OBJPROP_STYLE, STYLE_SOLID);

    return success;
}

#endif