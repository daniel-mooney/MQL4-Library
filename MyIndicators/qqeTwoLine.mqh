#ifndef QQE_MQH
#define QQE_MQH

#include <MQL4Library/Indicator/CIndicatorBase.mqh>
#include <MQL4Library/Indicator/CIndicatorSignal.mqh>

class QQETwoLine: public CIndicatorBase {
    public:
        QQETwoLine(
            string symbol,
            ENUM_TIMEFRAMES timeframe,
            int period,
            int smoothing_factor,
            double WP_multiplier,
            ENUM_MA_METHOD ma_method
        );

        CIndicatorSignal computeSignal();

    private:
        int period_;
        int smoothing_factor_;
        double WP_multiplier_;
        ENUM_MA_METHOD ma_method_;

        static string QQE_NAME_;
};

//---------------------- Constants ----------------------
string QQETwoLine::QQE_NAME_ = "MyIndicators/QQETwoLine averages histo + alerts + arrows";

//---------------------- Definitions ----------------------

QQETwoLine::QQETwoLine(
    string symbol,
    ENUM_TIMEFRAMES timeframe,
    int period,
    int smoothing_factor,
    double WP_multiplier,
    ENUM_MA_METHOD ma_method
)   : CIndicatorBase(symbol, timeframe)
    , period_(period)
    , smoothing_factor_(smoothing_factor)
    , WP_multiplier_(WP_multiplier)
    , ma_method_(ma_method)
{}

//----------
CIndicatorSignal QQETwoLine::computeSignal() {
    double fast_line = iCustom(
        symbol_,
        timeframe_,
        QQE_NAME_,
        ma_method_,
        smoothing_factor_,
        period_,
        MODE_CLOSE,
        WP_multiplier_,
        60.0,
        40.0,
        "Alert Settings",
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        "alert2.wav",
        false,
        "qqe Arrows 1",
        1.0,
        false,
        clrDeepSkyBlue,
        clrRed,
        223,
        234,
        1,
        1,
        true,
        clrLimeGreen,
        clrRed,
        119,
        119,
        2,
        2,
        3,
        0
    );

    double slow_line = iCustom(
        symbol_,
        timeframe_,
        QQE_NAME_,
        ma_method_,
        smoothing_factor_,
        period_,
        MODE_CLOSE,
        WP_multiplier_,
        60.0,
        40.0,
        "Alert Settings",
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        "alert2.wav",
        false,
        "qqe Arrows 1",
        1.0,
        false,
        clrDeepSkyBlue,
        clrRed,
        223,
        234,
        1,
        1,
        true,
        clrLimeGreen,
        clrRed,
        119,
        119,
        2,
        2,
        4,
        0
    );

    CIndicatorSignal signal = CIndicatorSignal::NONE;

    if (fast_line > slow_line) {
        signal = CIndicatorSignal::BUY;
    } else if (fast_line < slow_line) {
        signal = CIndicatorSignal::SELL;
    }

    return signal;
}               

#endif