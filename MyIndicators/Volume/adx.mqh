#ifndef ADX_MQH
#define ADX_MQH

#include <MQL4Library/Indicator/CIndicatorBase.mqh>
#include <MQL4Library/Indicator/CIndicatorSignal.mqh>

class ADX: public CIndicatorBase {
    public:
        ADX(
            string symbol,
            ENUM_TIMEFRAMES timeframe,
            int period
        );

        CIndicatorSignal computeSignal(
            int shift = 0
        );

    private:
        int period_;
};

//---------------------- Definitions ----------------------

ADX::ADX(
    string symbol,
    ENUM_TIMEFRAMES timeframe,
    int period
) :
    CIndicatorBase(symbol, timeframe),
    period_(period)
{}

//----------
CIndicatorSignal ADX::computeSignal(
    int shift
) {
    double adx = iADX(
        symbol_,
        timeframe_,
        period_,
        PRICE_CLOSE,
        MODE_MAIN,
        shift
    );

    CIndicatorSignal signal = CIndicatorSignal::NONE;

    if (adx >= 25) {
        signal = CIndicatorSignal::NEUTRAL;
    }

    return signal;
}

#endif 