#ifndef CHAIKINMONEYFLOW_MQH
#define CHAIKINMONEYFLOW_MQH

#include <MQL4Library/Indicator/CIndicatorBase.mqh>
#include <MQL4Library/Indicator/CIndicatorSignal.mqh>

class ChaikinMoneyFlow: public CIndicatorBase {
    public:
        ChaikinMoneyFlow(
            string symbol,
            ENUM_TIMEFRAMES timeframe,
            int period
        );

        CIndicatorSignal computeSignal(
            int shift
        );

    private:
        static string INDICATOR_NAME_;
        int period_;
};

string ChaikinMoneyFlow::INDICATOR_NAME_ = "MyIndicators/CMF_v1";

ChaikinMoneyFlow::ChaikinMoneyFlow(
    string symbol,
    ENUM_TIMEFRAMES timeframe,
    int period
) : CIndicatorBase(symbol, timeframe) {
    period_ = period;
}

CIndicatorSignal ChaikinMoneyFlow::computeSignal(
    int shift
) {
    double cmf = iCustom(
        symbol_,
        timeframe_,
        INDICATOR_NAME_,
        period_,
        0,
        shift
    );

    CIndicatorSignal signal = CIndicatorSignal::NONE;

    if (cmf > 0) {
        signal = CIndicatorSignal::BUY;
    } else if (cmf < 0) {
        signal = CIndicatorSignal::SELL;
    }

    return signal;
}

#endif