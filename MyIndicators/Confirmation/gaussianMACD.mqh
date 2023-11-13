#ifndef GAUSSIANMACD_MQH
#define GAUSSIANMACD_MQH

#include <MQL4Library/Indicator/CIndicatorBase.mqh>
#include <MQL4Library/Indicator/CIndicatorSignal.mqh>

class GaussianMACD: public CIndicatorBase {
    public:
        GaussianMACD(
            string symbol,
            ENUM_TIMEFRAMES timeframe,
            int fast_period,
            int slow_period,
            int signal_period
        );

        CIndicatorSignal computeSignal(
            int shift
        );
    
    private:
        static string INDICATOR_NAME_;

        int fast_period_;
        int slow_period_;
        int signal_period_;
};

string GaussianMACD::INDICATOR_NAME_ = "MyIndicators/Gaussian_MACD";

// Constructor
GaussianMACD::GaussianMACD(
    string symbol,
    ENUM_TIMEFRAMES timeframe,
    int fast_period,
    int slow_period,
    int signal_period
)   : CIndicatorBase(symbol, timeframe) 
    , fast_period_(fast_period)
    , slow_period_(slow_period)
    , signal_period_(signal_period)
{}

// ----------
CIndicatorSignal GaussianMACD::computeSignal(
    int shift
) {
    double macd_signal = iCustom(
        symbol_,
        timeframe_,
        INDICATOR_NAME_,
        fast_period_,
        slow_period_,
        signal_period_,
        0,
        shift
    );

    CIndicatorSignal signal = CIndicatorSignal::NONE;

    if (macd_signal > 0) {
        signal = CIndicatorSignal::BUY;
    } else if (macd_signal < 0) {
        signal = CIndicatorSignal::SELL;
    }

    return signal;
}

#endif