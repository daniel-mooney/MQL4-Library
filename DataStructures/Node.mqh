#ifndef NODE_MQH
#define NODE_MQH

template <typename T>
class Node {
    public:
        /**
         * @brief Construct a new Node object
         * 
         * @param data 
         */
        Node(T data) : data_(data), next_(NULL), prev_(NULL) {}

        /**
         * @brief Returns the data stored in the node
         * 
         * @return T 
         */
        T data() { return data_; }

        /**
         * @brief Get the Next node
         * 
         * @return Node<T>* 
         */
        Node<T>* next() { return next_; }

        /**
         * @brief Get the previous node
         * 
         * @return Node<T>* 
         */
        Node<T>* prev() { return prev_; }

        /**
         * @brief Set the Next object
         * 
         * @param next 
         */
        void setNext(Node<T>* next) { next_ = next; }

        /**
         * @brief Set the Prev object
         * 
         * @param prev 
         */
        void setPrev(Node<T>* prev) { prev_ = prev; }
    
    private:
        T data_;
        Node<T>* next_;
        Node<T>* prev_;
};

#endif