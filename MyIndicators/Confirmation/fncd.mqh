#ifndef FNCD_MQH
#define FNCD_MQH

#include <MQL4Library/Indicator/CIndicatorBase.mqh>
#include <MQL4Library/Indicator/CIndicatorSignal.mqh>

class FNCD: public CIndicatorBase {
    public:
        FNCD(
            string symbol,
            ENUM_TIMEFRAMES timeframe,
            int fn,
            double deviation,
            int fast_ema,
            int slow_ema
        );

        CIndicatorSignal computeSignal(
            int shift
        );
    
    private:
        static string INDICATOR_NAME_;

        int fn_;
        double deviation_;
        int fast_ema_;
        int slow_ema_;
};

string FNCD::INDICATOR_NAME_ = "MyIndicators/fncd";

//--- constructor
FNCD::FNCD(
    string symbol,
    ENUM_TIMEFRAMES timeframe,
    int fn,
    double deviation,
    int fast_ema,
    int slow_ema
)   : CIndicatorBase(symbol, timeframe)
    , fn_(fn)
    , deviation_(deviation)
    , fast_ema_(fast_ema)
    , slow_ema_(slow_ema)
{}

CIndicatorSignal FNCD::computeSignal(
    int shift
) {
    double fast_fn = iCustom(
        symbol_,
        timeframe_,
        INDICATOR_NAME_,
        fn_,
        deviation_,
        fast_ema_,
        slow_ema_,
        0,
        shift
    );

    double slow_fn = iCustom(
        symbol_,
        timeframe_,
        INDICATOR_NAME_,
        fn_,
        deviation_,
        fast_ema_,
        slow_ema_,
        1,
        shift
    );

    CIndicatorSignal signal = CIndicatorSignal::NONE;

    if (fast_fn > slow_fn) {
        signal = CIndicatorSignal::BUY;
    } else if (fast_fn < slow_fn) {
        signal = CIndicatorSignal::SELL;
    }

    return signal;
}

#endif