#ifndef VOLATILITYQUALITYHISTO_MQH
#define VOLATILITYQUALITYHISTO_MQH

#include <MQL4Library/Indicator/CIndicatorBase.mqh>
#include <MQL4Library/Indicator/CIndicatorSignal.mqh>

class VolatilityQualityHistogram: public CIndicatorBase {
    public:
        VolatilityQualityHistogram(
            string symbol,
            ENUM_TIMEFRAMES timeframe,
            int price_smoothing,
            ENUM_MA_METHOD smoothing_method,
            double filter_in_pips
        );

        CIndicatorSignal computeSignal(
            int shift
        );
    
    private:
        static string INDICATOR_NAME_;

        int price_smoothing_;
        ENUM_MA_METHOD smoothing_method_;
        double filter_in_pips_;
};

string VolatilityQualityHistogram::INDICATOR_NAME_ = "MyIndicators/Volatility_quality_histo";

// ----------
VolatilityQualityHistogram::VolatilityQualityHistogram(
    string symbol,
    ENUM_TIMEFRAMES timeframe,
    int price_smoothing,
    ENUM_MA_METHOD smoothing_method,
    double filter_in_pips
) : CIndicatorBase(symbol, timeframe) {
    price_smoothing_ = price_smoothing;
    smoothing_method_ = smoothing_method;
    filter_in_pips_ = filter_in_pips;
}

// ----------
CIndicatorSignal VolatilityQualityHistogram::computeSignal(
    int shift
) {
    double vqh = iCustom(
        symbol_,
        timeframe_,
        INDICATOR_NAME_,
        timeframe_,
        "",
        price_smoothing_,
        smoothing_method_,
        filter_in_pips_,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        0,
        shift
    );

    double value_2 = iCustom(
        symbol_,
        timeframe_,
        INDICATOR_NAME_,
        timeframe_,
        "",
        price_smoothing_,
        smoothing_method_,
        filter_in_pips_,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        1,
        shift
    );

    CIndicatorSignal signal = CIndicatorSignal::NONE;

    if (vqh != EMPTY_VALUE) {
        signal = CIndicatorSignal::BUY;
    } else if (value_2 != EMPTY_VALUE) {
        signal = CIndicatorSignal::SELL;
    }

    return signal;
}

#endif