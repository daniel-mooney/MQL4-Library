#ifndef CCI_MQH
#define CCI_MQH

#include <MQL4Library/Indicator/CIndicatorBase.mqh>
#include <MQL4Library/Indicator/CIndicatorSignal.mqh>

class Cci: public CIndicatorBase {
    public:
        Cci(
            string symbol,
            ENUM_TIMEFRAMES timeframe,
            int period,
            int applied_price = PRICE_TYPICAL,
            int shift = 0
        );

        CIndicatorSignal computeSignal(
            int shift = 0
        );
    
    private:
        int period_;
        int applied_price_;
        int shift_;
};

// ---------------------- Definitions
Cci::Cci(
    string symbol,
    ENUM_TIMEFRAMES timeframe,
    int period,
    int applied_price,
    int shift
)   : CIndicatorBase(symbol, timeframe)
    , period_(period)
    , applied_price_(applied_price)
    , shift_(shift)
{}

// ----------
CIndicatorSignal Cci::computeSignal(
    int shift
) {
    double cci = iCCI(
        symbol_,
        timeframe_,
        period_,
        applied_price_,
        shift
    );

    // Zero cross
    CIndicatorSignal signal = CIndicatorSignal::NONE;

    if (cci > 0) {
        signal = CIndicatorSignal::BUY;
    } else if (cci < 0) {
        signal = CIndicatorSignal::SELL;
    }

    return signal;
}

#endif