#ifndef OBJECT_NODE_MQH
#define OBJECT_NODE_MQH


/**
 * @brief A node in a linked list of objects
 * 
 * @tparam T 
 */
template <typename T>
class ObjectNode {
    public:
        /**
         * @brief Construct a new ObjectNode object
         * 
         * @param data 
         */
        ObjectNode(T& data) : data_(data), next_(NULL), prev_(NULL) {}

        /**
         * @brief Returns a pointer to the data 
         * stored in the node
         * 
         * @return T*
         */
        T* data() { return &data_; }

        /**
         * @brief Returns a pointer to the next 
         * node in the list
         * 
         * @return ObjectNode<T>* 
         */
        ObjectNode<T>* next() { return next_; }

        /**
         * @brief Returns a pointer to the previous
         * node in the list
         * 
         * @return ObjectNode<T>* 
         */
        ObjectNode<T>* prev() { return prev_; }

        /**
         * @brief Sets the next node in the list
         * 
         * @param next 
         */
        void setNext(ObjectNode<T>* next) { next_ = next; }

        /**
         * @brief Sets the previous node in the list
         * 
         * @param prev 
         */
        void setPrev(ObjectNode<T>* prev) { prev_ = prev; }
    
    private:
        T data_;
        ObjectNode<T>* next_;
        ObjectNode<T>* prev_;
};

#endif