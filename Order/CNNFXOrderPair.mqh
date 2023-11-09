#ifndef CNNFX_ORDER_PAIR_MQH
#define CNNFX_ORDER_PAIR_MQH

/**
 * @brief Stores the pairs of order tickets for a NNFX order
 * @note The actual order object should be stored in the order pool,
 * 
 */
class CNNFXOrderPair {
    public:
        /**
         * @brief Default constructor
         * 
         */
        CNNFXOrderPair();

        /**
         * @brief Constructs a new CNNFXOrderPair object
         * 
         * @param takeprofit_ticket 
         * @param runner_ticket 
         */
        CNNFXOrderPair(
            int take_profit_ticket,
            int runner_ticket
        );

        /**
         * @brief Copy constructor
         * 
         * @param copy 
         */
        CNNFXOrderPair(const CNNFXOrderPair& copy);

        /**
         * @brief Returns the ticket of the takeprofit order
         * 
         * @return int 
         */
        int takeProfitTicket() const;

        /**
         * @brief Returns the ticket of the runner order
         * 
         * @return int 
         */
        int runnerTicket() const;

        /**
         * @brief Sets the take profit boolean to true
         * 
         */
        void takeProfit();
        
        /**
         * @brief Returns true if the take profit has been taken
         * 
         * @return bool
         */
        bool hasTakenProfit() const;

        /**
         * @brief Comparison operator
         * 
         * @param rhs 
         * @return bool
         */
        bool operator==(const CNNFXOrderPair& rhs) const;

    
    private:
        int take_profit_ticket_;
        int runner_ticket_;
        bool taken_profit_;
};

// ---------------------- Definitions ----------------------

CNNFXOrderPair::CNNFXOrderPair()
:   take_profit_ticket_(0)
,   runner_ticket_(0)
,   taken_profit_(false)
{}

// ----------
CNNFXOrderPair::CNNFXOrderPair(
    int take_profit_ticket,
    int runner_ticket
)   : take_profit_ticket_(take_profit_ticket)
    , runner_ticket_(runner_ticket)
    , taken_profit_(false)
{}

// ----------
CNNFXOrderPair::CNNFXOrderPair(
    const CNNFXOrderPair& copy
)   : take_profit_ticket_(copy.take_profit_ticket_)
    , runner_ticket_(copy.runner_ticket_)
    , taken_profit_(copy.taken_profit_)
{}

// ----------
int CNNFXOrderPair::takeProfitTicket() const {
    return take_profit_ticket_;
}

// ----------
int CNNFXOrderPair::runnerTicket() const {
    return runner_ticket_;
}

// ----------
void CNNFXOrderPair::takeProfit() {
    taken_profit_ = true;
}

// ----------
bool CNNFXOrderPair::hasTakenProfit() const {
    return taken_profit_;
}

// ----------
bool CNNFXOrderPair::operator==(const CNNFXOrderPair& rhs) const {
    bool take_profit_ticket = take_profit_ticket_ == rhs.take_profit_ticket_;
    bool runner_ticket = runner_ticket_ == rhs.runner_ticket_;
    bool taken_profit = taken_profit_ == rhs.taken_profit_;

    return (
        take_profit_ticket
        && runner_ticket
        && taken_profit
    );
}
#endif