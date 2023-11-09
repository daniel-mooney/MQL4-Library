#ifndef NNFX_TESTER_MQH
#define NNFX_TESTER_MQH

#include <MQL4Library/Event/CEventListenerBase.mqh>
#include <MQL4Library/Order/COrder.mqh>

enum ENUM_TradeResult {
    TR_WIN,
    TR_LOSS,
    TR_NONE
};

class CNNFXTester: public CEventListenerBase {
    public:
        CNNFXTester();

        /**
         * @brief Returns the number of wins.
         * 
         * @return int 
         */
        int winCount() const;

        /**
         * @brief Returns the number of losses.
         * 
         * @return int 
         */
        int lossCount() const;

        /**
         * @brief Returns the last trade result.
         * @note Sets the last trade result to TR_NONE.
         * 
         * @return ENUM_TradeResult 
         */
        ENUM_TradeResult lastResult();

        void takeProfitCallback(const COrder& order) override;

        void stopLossCallback(const COrder& order) override;

    private:
        int wins_;
        int losses_;
        ENUM_TradeResult last_result_;
};

// ---------- Definitions ----------

CNNFXTester::CNNFXTester()
    : CEventListenerBase()
    , wins_(0)
    , losses_(0)
    , last_result_(TR_NONE)
{}

// ----------
int CNNFXTester::winCount() const {
    return wins_;
}

// ----------
int CNNFXTester::lossCount() const {
    return losses_;
}

// ----------
ENUM_TradeResult CNNFXTester::lastResult() {
    ENUM_TradeResult result = last_result_;
    last_result_ = TR_NONE;
    return result;
}

// ----------
void CNNFXTester::takeProfitCallback(const COrder& order) {
    wins_++;
    last_result_ = TR_WIN;
    return;
}

// ----------
void CNNFXTester::stopLossCallback(const COrder& order) {
    if (order.getTakeProfit() != 0) {
        losses_++;
        last_result_ = TR_LOSS;
    }
    return;
}

#endif