#ifndef VOLATILITYINDICATOR_MQH
#define VOLATILITYINDICATOR_MQH

#include <MQL4Library/Indicator/CIndicatorBase.mqh>
#include <MQL4Library/Indicator/CIndicatorSignal.mqh>

class VolatilityIndicator: public CIndicatorBase {
    public:
        VolatilityIndicator(
            string symbol,
            ENUM_TIMEFRAMES timeframe,
            int volatility_period,
            int ma_period,
            ENUM_MA_METHOD ma_method
        );

        CIndicatorSignal computeSignal(
            int shift
        );

    private:
        static string INDICATOR_NAME_;

        int volatility_period_;
        int ma_period_;
        ENUM_MA_METHOD ma_method_;
};

string VolatilityIndicator::INDICATOR_NAME_ = "MyIndicators/volatility-indicator";

// Constructor
VolatilityIndicator::VolatilityIndicator(
    string symbol,
    ENUM_TIMEFRAMES timeframe,
    int volatility_period,
    int ma_period,
    ENUM_MA_METHOD ma_method
)   : CIndicatorBase(symbol, timeframe) 
    , volatility_period_(volatility_period)
    , ma_period_(ma_period)
    , ma_method_(ma_method)
{}

// ----------
CIndicatorSignal VolatilityIndicator::computeSignal(
    int shift
) {
    double volatility_values[];
    ArrayResize(volatility_values, ma_period_);
    ArraySetAsSeries(volatility_values, true);

    for (int i = 0; i < ma_period_; i++) {
        volatility_values[i] = iCustom(
            symbol_,
            timeframe_,
            INDICATOR_NAME_,
            volatility_period_,
            0,
            shift + i
        );
    }

    double average = iMAOnArray(
        volatility_values,
        ma_period_,
        ma_period_,
        0,
        ma_method_,
        0
    );

    CIndicatorSignal signal = CIndicatorSignal::NONE;

    if (volatility_values[0] > average) {
        signal = CIndicatorSignal::NEUTRAL;
    }

    return signal;
}

#endif