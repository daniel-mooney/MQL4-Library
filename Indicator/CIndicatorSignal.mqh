#ifndef CINDICATORSIGNAL_MQH
#define CINDICATORSIGNAL_MQH

#property copyright     "No copyright, Daniel Mooney"
#property version       "1.0"
#property library

enum SignalType {
            I_NONE,
            I_NEUTRAL,
            I_BUY,
            I_SELL            
        };

class CIndicatorSignal {
    public:
        static const CIndicatorSignal NONE;
        static const CIndicatorSignal NEUTRAL;
        static const CIndicatorSignal BUY;
        static const CIndicatorSignal SELL;

        /**
         * @brief Constructs a new CIndicatorSignal object
         * 
         * @param signal 
         */
        CIndicatorSignal(
            SignalType signal
        );

        /**
         * @brief Copy constructor
         * 
         * @param rhs 
         */
        CIndicatorSignal(
            const CIndicatorSignal& rhs
        );

        SignalType getSignalType() const;

        /**
         * @brief Provides signal combination logic
         * 
         * @param rhs 
         * @return CIndicatorSignal 
         */
        const CIndicatorSignal operator+ (const CIndicatorSignal& rhs) const;

        bool operator== (const CIndicatorSignal& rhs) const;

        bool operator!= (const CIndicatorSignal& rhs) const;
    
    private:   
        SignalType signal_;
};

// ---------------------- Static definitions
const CIndicatorSignal CIndicatorSignal::NONE = CIndicatorSignal(SignalType::I_NONE);
const CIndicatorSignal CIndicatorSignal::NEUTRAL = CIndicatorSignal(SignalType::I_NEUTRAL);
const CIndicatorSignal CIndicatorSignal::BUY = CIndicatorSignal(SignalType::I_BUY);
const CIndicatorSignal CIndicatorSignal::SELL = CIndicatorSignal(SignalType::I_SELL);


// ---------------------- Definitions
CIndicatorSignal::CIndicatorSignal(
    SignalType signal
) : signal_(signal) {}

// ----------
CIndicatorSignal::CIndicatorSignal(
    const CIndicatorSignal& rhs
) : signal_(rhs.signal_) {}

// ----------
SignalType CIndicatorSignal::getSignalType() const {
    return signal_;
}

// ----------
const CIndicatorSignal CIndicatorSignal::operator+ (const CIndicatorSignal& rhs) const {
    //--- None
    if (signal_ == SignalType::I_NONE || rhs.signal_ == SignalType::I_NONE) {
        return CIndicatorSignal(SignalType::I_NONE);
    }

    //--- Neutral
    if (signal_ == SignalType::I_NEUTRAL) {
        return CIndicatorSignal(rhs.signal_);
    }

    if (rhs.signal_ == SignalType::I_NEUTRAL) {
        return CIndicatorSignal(signal_);
    }

    //--- Buy and Sell
    if (signal_ != rhs.signal_) {
        return CIndicatorSignal(SignalType::I_NONE);
    } else {
        return CIndicatorSignal(signal_);
    }
}

// ----------
bool CIndicatorSignal::operator== (const CIndicatorSignal& rhs) const {
    return signal_ == rhs.signal_;
}

// ----------
bool CIndicatorSignal::operator!= (const CIndicatorSignal& rhs) const {
    return signal_ != rhs.signal_;
}

#endif // CINDICATORSIGNAL_MQH