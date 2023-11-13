#ifndef THREE_D_MQH
#define THREE_D_MQH

#include <MQL4Library/Indicator/CIndicatorBase.mqh>
#include <MQL4Library/Indicator/CIndicatorSignal.mqh>

class ThreeD: public CIndicatorBase {
    public:
        ThreeD(
            string symbol,
            ENUM_TIMEFRAMES timeframe,
            int rsi_period,
            int stochastic_period,
            int tunnel_period,
            double hot,
            double sig_smooth
        );

        CIndicatorSignal computeSignal(
            int shift
        );

    private:
        static string INDICATOR_NAME_;

        int rsi_period_;
        int stochastic_period_;
        int tunnel_period_;
        double hot_;
        double sig_smooth_;

};

string ThreeD::INDICATOR_NAME_ = "MyIndicators/3d";

//--- constructor
ThreeD::ThreeD(
    string symbol,
    ENUM_TIMEFRAMES timeframe,
    int rsi_period,
    int stochastic_period,
    int tunnel_period,
    double hot,
    double sig_smooth
)   : CIndicatorBase(symbol, timeframe)
    , rsi_period_(rsi_period)
    , stochastic_period_(stochastic_period)
    , tunnel_period_(tunnel_period)
    , hot_(hot)
    , sig_smooth_(sig_smooth)
{}

// ----------
CIndicatorSignal ThreeD::computeSignal(
    int shift
) {
    double three_d = iCustom(
        symbol_,
        timeframe_,
        INDICATOR_NAME_,
        rsi_period_,
        stochastic_period_,
        tunnel_period_,
        hot_,
        sig_smooth_,
        0,
        shift
    );

    double value_2 = iCustom(
        symbol_,
        timeframe_,
        INDICATOR_NAME_,
        rsi_period_,
        stochastic_period_,
        tunnel_period_,
        hot_,
        sig_smooth_,
        1,
        shift
    );

    CIndicatorSignal signal = CIndicatorSignal::NONE;

    if (three_d > value_2) {
        signal = CIndicatorSignal::BUY;
    } else if (three_d < value_2) {
        signal = CIndicatorSignal::SELL;
    }

    return signal;
}

#endif