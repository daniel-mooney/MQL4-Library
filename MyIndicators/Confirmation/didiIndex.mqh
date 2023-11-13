#ifndef DIDI_INDEX_MQH
#define DIDI_INDEX_MQH

#include <MQL4Library/Indicator/CIndicatorBase.mqh>
#include <MQL4Library/Indicator/CIndicatorSignal.mqh>

class DidiIndex: public CIndicatorBase {
    public:
        DidiIndex(
            string symbol,
            ENUM_TIMEFRAMES timeframe,
            int curta,
            ENUM_APPLIED_PRICE curta_applied_price,
            ENUM_MA_METHOD curta_ma_method,
            int media,
            ENUM_APPLIED_PRICE media_applied_price,
            ENUM_MA_METHOD media_ma_method,
            int longa,
            ENUM_APPLIED_PRICE longa_applied_price,
            ENUM_MA_METHOD longa_ma_method
        );

        CIndicatorSignal computeSignal(
            int shift
        );

    private:
        static string INDICATOR_NAME_;

        int curta_;
        ENUM_APPLIED_PRICE curta_applied_price_;
        ENUM_MA_METHOD curta_ma_method_;
        int media_;
        ENUM_APPLIED_PRICE media_applied_price_;
        ENUM_MA_METHOD media_ma_method_;
        int longa_;
        ENUM_APPLIED_PRICE longa_applied_price_;
        ENUM_MA_METHOD longa_ma_method_;
};

string DidiIndex::INDICATOR_NAME_ = "MyIndicators/Didi_Index";

//--- constructor
DidiIndex::DidiIndex(
    string symbol,
    ENUM_TIMEFRAMES timeframe,
    int curta,
    ENUM_APPLIED_PRICE curta_applied_price,
    ENUM_MA_METHOD curta_ma_method,
    int media,
    ENUM_APPLIED_PRICE media_applied_price,
    ENUM_MA_METHOD media_ma_method,
    int longa,
    ENUM_APPLIED_PRICE longa_applied_price,
    ENUM_MA_METHOD longa_ma_method
)   : CIndicatorBase(symbol, timeframe)
    , curta_(curta)
    , curta_applied_price_(curta_applied_price)
    , curta_ma_method_(curta_ma_method)
    , media_(media)
    , media_applied_price_(media_applied_price)
    , media_ma_method_(media_ma_method)
    , longa_(longa)
    , longa_applied_price_(longa_applied_price)
    , longa_ma_method_(longa_ma_method)
{}

// ----------
CIndicatorSignal DidiIndex::computeSignal(
    int shift
) {
    double curta = iCustom(
        symbol_,
        timeframe_,
        INDICATOR_NAME_,
        curta_,
        curta_applied_price_,
        curta_ma_method_,
        media_,
        media_applied_price_,
        media_ma_method_,
        longa_,
        longa_applied_price_,
        longa_ma_method_,
        0,
        shift 
    );

    double longa = iCustom(
        symbol_,
        timeframe_,
        INDICATOR_NAME_,
        curta_,
        curta_applied_price_,
        curta_ma_method_,
        media_,
        media_applied_price_,
        media_ma_method_,
        longa_,
        longa_applied_price_,
        longa_ma_method_,
        2,
        shift 
    );

    CIndicatorSignal signal = CIndicatorSignal::NONE;

    if (curta > longa) {
        signal = CIndicatorSignal::BUY;
    } else if (curta < longa) {
        signal = CIndicatorSignal::SELL;
    }

    return signal;
}

#endif 