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
         * @brief Returns a reference to the data 
         * stored in the node
         * 
         * @return T& 
         */
        T& data() { return data_; }

        /**
         * @brief Returns a pointer to the next 
         * node in the list
         * 
         * @return Node<T>* 
         */
        Node<T>* next() { return next_; }

        /**
         * @brief Returns a pointer to the previous
         * node in the list
         * 
         * @return Node<T>* 
         */
        Node<T>* prev() { return prev_; }

        /**
         * @brief Sets the next node in the list
         * 
         * @param next 
         */
        void setNext(Node<T>* next) { next_ = next; }

        /**
         * @brief Sets the previous node in the list
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