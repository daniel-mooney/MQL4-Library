#ifndef ALMA_MQH
#define ALMA_MQH

#include <MQL4Library/Indicator/CIndicatorBase.mqh>
#include <MQL4Library/Indicator/CIndicatorSignal.mqh>

class ALMA: public CIndicatorBase {
    public:
        ALMA(
            string symbol,
            ENUM_TIMEFRAMES timeframe,
            double period,
            double sigma,
            double sample,
            bool atr_bands,
            double atr_multiplier
        );

        CIndicatorSignal computeSignal();
    
    private:
        bool atr_bands_;
        double atr_multiplier_;  

        const int period_;
        const double sigma_;
        const double sample_;

        static void alma_coefficients(
            const int period,
            const double sigma,
            const double sample,
            double& coeffs[]
        );

        static double alma(
            string symbol,
            int timeframe,
            const int period,
            const double sigma,
            const double sample,
            const ENUM_APPLIED_PRICE price,
            const int shift = 0
        );
};

// ---------------------- Definitions ----------------------

ALMA::ALMA(
    string symbol,
    ENUM_TIMEFRAMES timeframe,
    double period,
    double sigma,
    double sample,
    bool atr_bands,
    double atr_multiplier
)   : CIndicatorBase(
        symbol,
        timeframe
    )
    , atr_bands_(atr_bands)
    , atr_multiplier_(atr_multiplier)
    , period_(period)
    , sigma_(sigma)
    , sample_(sample)
{}

// ----------
CIndicatorSignal ALMA::computeSignal() {
    double alma = alma(
        symbol_,
        timeframe_,
        period_,
        sigma_,
        sample_,
        PRICE_CLOSE
    );

    CIndicatorSignal signal = CIndicatorSignal::NONE;
    double close = iClose(symbol_, timeframe_, 0);

    if (close > alma) {
        signal = CIndicatorSignal::BUY;
    } else if (close < alma) {
        signal = CIndicatorSignal::SELL;
    }

    double atr = iATR(
        symbol_,
        timeframe_,
        14,
        0
    );

    if (
        atr_bands_ 
        && (close > alma + atr || close < alma - atr)
    ) {
        signal = CIndicatorSignal::NONE;
    } 

    return signal;
}

// ----------
void ALMA::alma_coefficients(
    const int period,
    const double sigma,
    const double sample,
    double& coeffs[]
) {
    ArrayResize(coeffs, period);

    double m = MathFloor(sample * (period - 1));
    double s = period / sigma;
    double d = 2 * s * s;

    double sum = 0.0;
    for (int i = 0; i < period; i++) {
        double w = MathExp(-MathPow(i - m, 2) / d);
        coeffs[i] = w;
        sum += w;
    }

    if (sum == 0.0) {
        Print("WARNING [ALMA]: sum of coefficients is zero");
    }

    // Normalize coefficients
    for (int j = 0; j < period; j++) {
        coeffs[j] /= sum;
    }

    return;
}

// ----------
double ALMA::alma(
    string symbol,
    int timeframe,
    const int period,
    const double sigma,
    const double sample,
    const ENUM_APPLIED_PRICE price,
    const int shift = 0
) {
    double coeffs[];
    alma_coefficients(period, sigma, sample, coeffs);

    double sum = 0.0;
    for (int i = 0; i < period; i++) {
        // iMA hack to get price type
        sum += coeffs[i] * iMA(
            symbol,
            timeframe,
            1,
            0,
            MODE_SMA,
            price,
            shift + (period - 1 - i)
        );
    }

    return sum;
}

#endif