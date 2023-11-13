#ifndef BH_ERGODIC_MTF__ARROWS_MQH
#define BH_ERGODIC_MTF__ARROWS_MQH

#include <MQL4Library/Indicator/CIndicatorBase.mqh>
#include <MQL4Library/Indicator/CIndicatorSignal.mqh>

class BhErgodic : public CIndicatorBase {
    public:
        BhErgodic(
            string symbol,
            ENUM_TIMEFRAMES timeframe,
            int first_ema_period,
            int second_ema_period,
            int third_ema_period,
            int signal_ema_period,
            ENUM_APPLIED_PRICE price
        );

        CIndicatorSignal computeSignal(
            int shift
        );

    private:
        static string INDICATOR_NAME_;

        int first_ema_period_;
        int second_ema_period_;
        int third_ema_period_;
        int signal_ema_period_;
        ENUM_APPLIED_PRICE price_;
};

string BhErgodic::INDICATOR_NAME_ = "MyIndicators/BH_-_ergodic_mtf__arrows";

//--- constructor
BhErgodic::BhErgodic(
    string symbol,
    ENUM_TIMEFRAMES timeframe,
    int first_ema_period,
    int second_ema_period,
    int third_ema_period,
    int signal_ema_period,
    ENUM_APPLIED_PRICE price
)   : CIndicatorBase(symbol, timeframe)
    , first_ema_period_(first_ema_period)
    , second_ema_period_(second_ema_period)
    , third_ema_period_(third_ema_period)
    , signal_ema_period_(signal_ema_period)
    , price_(price)
{}

// ----------
CIndicatorSignal BhErgodic::computeSignal(
    int shift
) {
    double bh_ergodic = iCustom(
        symbol_,
        timeframe_,
        INDICATOR_NAME_,
        timeframe_,
        first_ema_period_,
        second_ema_period_,
        third_ema_period_,
        signal_ema_period_,
        price_,
        false,
        false,
        "erg Arrows 1",
        0.1,
        0.1,
        clrBlue,
        clrCrimson,
        116,
        116,
        2,
        2,
        true,
        0,
        shift
    );

    double value_2 = iCustom(
        symbol_,
        timeframe_,
        INDICATOR_NAME_,
        timeframe_,
        first_ema_period_,
        second_ema_period_,
        third_ema_period_,
        signal_ema_period_,
        price_,
        false,
        false,
        "erg Arrows 1",
        0.1,
        0.1,
        clrBlue,
        clrCrimson,
        116,
        116,
        2,
        2,
        true,
        1,
        shift
    );

    CIndicatorSignal signal = CIndicatorSignal::NONE;

    if (bh_ergodic > value_2) {
        signal = CIndicatorSignal::BUY;
    } else if (bh_ergodic < value_2) {
        signal = CIndicatorSignal::SELL;
    }

    return signal;
}

#endif