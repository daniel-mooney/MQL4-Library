#ifndef STDDEVMA_MQH
#define STDDEVMA_MQH

#include <MQL4Library/Indicator/CIndicatorBase.mqh>
#include <MQL4Library/Indicator/CIndicatorSignal.mqh>

class StdDevMA: public CIndicatorBase {
    public:
        StdDevMA(
            string symbol,
            ENUM_TIMEFRAMES timeframe,
            int stddev_period,
            ENUM_MA_METHOD stddev_method,
            int ma_period,
            ENUM_MA_METHOD ma_method
        );

        CIndicatorSignal computeSignal();

    private:
        int stddev_period_;
        ENUM_MA_METHOD stddev_method_;
        int ma_period_;
        ENUM_MA_METHOD ma_method_;
};

//---------------------- Definitions ----------------------

StdDevMA::StdDevMA(
    string symbol,
    ENUM_TIMEFRAMES timeframe,
    int stddev_period,
    ENUM_MA_METHOD stddev_method,
    int ma_period,
    ENUM_MA_METHOD ma_method
)   : CIndicatorBase(symbol, timeframe)
    , stddev_period_(stddev_period)
    , stddev_method_(stddev_method)
    , ma_period_(ma_period)
    , ma_method_(ma_method)
{}

//----------
CIndicatorSignal StdDevMA::computeSignal() {
    // Create array of std dev values
    double stddev[];
    ArrayResize(stddev, ma_period_);

    for (int i = 0; i < ma_period_; i++) {
        stddev[i] = iStdDev(
            symbol_,
            timeframe_,
            stddev_period_,
            0,
            stddev_method_,
            PRICE_CLOSE,
            i
        );
    }

    double average = iMAOnArray(
        stddev,
        ma_period_,
        ma_period_,
        0,
        ma_method_,
        0
    );

    CIndicatorSignal signal = CIndicatorSignal::NONE;

    if (stddev[0] > average) {
        signal = CIndicatorSignal::NEUTRAL;
    }

    return signal;
}

#endif