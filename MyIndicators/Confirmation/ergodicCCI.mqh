#ifndef ERGOCCI_MQH
#define ERGOCCI_MQH

#include <MQL4Library/Indicator/CIndicatorBase.mqh>
#include <MQL4Library/Indicator/CIndicatorSignal.mqh>

class ErgodicCCI: public CIndicatorBase {
    public:
        ErgodicCCI(
            string symbol,
            ENUM_TIMEFRAMES timeframe,
            int pq,
            int pr,
            int ps,
            int trigger,
            int smoothing_period
        );

        CIndicatorSignal computeSignal(
            int shift
        );

    private:
        static string INDICATOR_NAME_;

        int pq_;
        int pr_;
        int ps_;
        int trigger_;
        int smoothing_period_;
};

string ErgodicCCI::INDICATOR_NAME_ = "MyIndicators/Fx Sniper Ergodic CCI Trigger Alert Fast mtf arrows_v1 nmc - Copy";

// ----------
ErgodicCCI::ErgodicCCI(
    string symbol,
    ENUM_TIMEFRAMES timeframe,
    int pq,
    int pr,
    int ps,
    int trigger,
    int smoothing_period
)   : CIndicatorBase(symbol, timeframe)
    , pq_(pq)
    , pr_(pr)
    , ps_(ps)
    , trigger_(trigger)
    , smoothing_period_(smoothing_period)
{}

// ----------
CIndicatorSignal ErgodicCCI::computeSignal(
    int shift
) {
    double ergodic_cci = iCustom(
        symbol_,
        timeframe_,
        INDICATOR_NAME_,
        "",
        "Current time frame",
        pq_,
        pr_,
        ps_,
        smoothing_period_,
        0,
        false,
        "cci cross",
        clrAqua,
        clrRed,
        true,
        "alerts settings",
        false,
        false,
        false,
        false,
        false,
        0,
        shift
    );

    double trigger_line = iCustom(
        symbol_,
        timeframe_,
        INDICATOR_NAME_,
        "",
        "Current time frame",
        pq_,
        pr_,
        ps_,
        smoothing_period_,
        0,
        false,
        "cci cross",
        clrAqua,
        clrRed,
        true,
        "alerts settings",
        false,
        false,
        false,
        false,
        false,
        1,
        shift
    );

    CIndicatorSignal signal = CIndicatorSignal::NONE;

    if (ergodic_cci > trigger_line) {
        signal = CIndicatorSignal::BUY;
    } else if (ergodic_cci < trigger_line) {
        signal = CIndicatorSignal::SELL;
    }

    return signal;
}

#endif