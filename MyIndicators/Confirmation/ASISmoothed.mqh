#ifndef ASI_SMOOTHED_MQH
#define ASI_SMOOTHED_MQH

#include <MQL4Library/Indicator/CIndicatorBase.mqh>
#include <MQL4Library/Indicator/CIndicatorSignal.mqh>

class ASISmoothed: public CIndicatorBase {
    public:
        ASISmoothed(
            string symbol,
            ENUM_TIMEFRAMES timeframe,
            int smoothing_period,
            ENUM_MA_METHOD smoothing_method,
            int ma_period,
            ENUM_MA_METHOD ma_method,
            ENUM_APPLIED_PRICE applied_price
        );

        CIndicatorSignal computeSignal(
            int shift
        );

    private:
        static string INDICATOR_NAME_;

        int smoothing_period_;
        ENUM_MA_METHOD smoothing_method_;
        int ma_period_;
        ENUM_MA_METHOD ma_method_;
        ENUM_APPLIED_PRICE applied_price_;
};

string ASISmoothed::INDICATOR_NAME_ = "MyIndicators/ASI_smoothed";

//--- constructor
ASISmoothed::ASISmoothed(
    string symbol,
    ENUM_TIMEFRAMES timeframe,
    int smoothing_period,
    ENUM_MA_METHOD smoothing_method,
    int ma_period,
    ENUM_MA_METHOD ma_method,
    ENUM_APPLIED_PRICE applied_price
)   : CIndicatorBase(symbol, timeframe)
    , smoothing_period_(smoothing_period)
    , smoothing_method_(smoothing_method)
    , ma_period_(ma_period)
    , ma_method_(ma_method)
    , applied_price_(applied_price)
{}

// ----------
CIndicatorSignal ASISmoothed::computeSignal(
    int shift
) {
    // Apply moving average to ASI smoothed
    double asi_smoothed = iCustom(
        symbol_,
        timeframe_,
        INDICATOR_NAME_,
        smoothing_period_,
        smoothing_method_,
        ma_period_,
        ma_method_,
        applied_price_,
        0,
        shift
    );

    double asi_ma = iCustom(
        symbol_,
        timeframe_,
        INDICATOR_NAME_,
        smoothing_period_,
        smoothing_method_,
        ma_period_,
        ma_method_,
        applied_price_,
        1,
        shift
    );

    CIndicatorSignal signal = CIndicatorSignal::NONE;

    if (asi_smoothed > asi_ma) {
        signal = CIndicatorSignal::BUY;
    } else if (asi_smoothed < asi_ma) {
        signal = CIndicatorSignal::SELL;
    }

    return signal;
}

#endif