#ifndef ABSOLUTE_STRENGTH_HISTO_MQH
#define ABSOLUTE_STRENGTH_HISTO_MQH

#include <MQL4Library/Indicator/CIndicatorBase.mqh>
#include <MQL4Library/Indicator/CIndicatorSignal.mqh>

class AbsoluteStrengthHistogram: public CIndicatorBase {
    public:
        AbsoluteStrengthHistogram(
            string symbol,
            ENUM_TIMEFRAMES timeframe,
            int mode,
            int length,
            int smooth,
            int signal,
            ENUM_APPLIED_PRICE price,
            ENUM_MA_METHOD mode_ma
        );

        CIndicatorSignal computeSignal(
            int shift = 0
        );

    private:
        static string INDICATOR_NAME_;

        int mode_;
        int length_;
        int smooth_;
        int signal_;
        ENUM_APPLIED_PRICE price_;
        ENUM_MA_METHOD mode_ma_;
};

//--- Constants
string AbsoluteStrengthHistogram::INDICATOR_NAME_ = "MyIndicators/absolute-strength-histogram";

//--- Constructor
AbsoluteStrengthHistogram::AbsoluteStrengthHistogram(
    string symbol,
    ENUM_TIMEFRAMES timeframe,
    int mode,
    int length,
    int smooth,
    int signal,
    ENUM_APPLIED_PRICE price,
    ENUM_MA_METHOD mode_ma
)   : CIndicatorBase(symbol, timeframe)
    , mode_(mode)
    , length_(length)
    , smooth_(smooth)
    , signal_(signal)
    , price_(price)
    , mode_ma_(mode_ma)
{}

// ----------
CIndicatorSignal AbsoluteStrengthHistogram::computeSignal(
    int shift
) {
    double bulls = iCustom(
        symbol_,
        timeframe_,
        INDICATOR_NAME_,
        mode_,
        length_,
        smooth_,
        signal_,
        price_,
        mode_ma_,
        2,
        shift
    );

    double bears = iCustom(
        symbol_,
        timeframe_,
        INDICATOR_NAME_,
        mode_,
        length_,
        smooth_,
        signal_,
        price_,
        mode_ma_,
        3,
        shift
    );

    CIndicatorSignal signal = CIndicatorSignal::NONE;

    if (bulls > bears) {
        signal = CIndicatorSignal::BUY;
    } else if (bulls < bears) {
        signal = CIndicatorSignal::SELL;
    }

    return signal;
}

#endif