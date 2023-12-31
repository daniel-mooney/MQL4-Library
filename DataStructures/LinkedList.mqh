#ifndef LINKED_LIST_MQH
#define LINKED_LIST_MQH

#include <MQL4Library/DataStructures/Node.mqh>

template <typename T>
class LinkedList {
    public:
        /**
         * @brief Predicate function used for identifying nodes
         * 
         */
        typedef bool (*predicate)(const T&);

        /**
         * @brief Construct a new Linked List object
         * @note The head and tail pointers are initialized
         * to NULL and the size is initialized to 0
         * 
         */
        LinkedList() : head_(NULL), tail_(NULL), size_(0) {}

        /**
         * @brief Destroy the Linked List object
         * @note The destructor should call the clear function
         * to free all memory associated with the list
         * 
         */
        ~LinkedList() {
            Node<T>* curr = head_;

            for (int i = 0; i < size_ && curr != NULL; i++) {
                Node<T>* next = curr.next();
                delete curr;
                curr = next;
            }
        }

        /**
         * @brief Returns the size of the list
         * 
         * @return int 
         */
        int size() const { return size_; }

        /**
         * @brief Places a new Node at the front of the list
         * 
         * @param data 
         */
        void push_front(T data) {
            Node<T>* node = new Node<T>(data);

            if (head_ == NULL) {
                head_ = node;
                tail_ = node;
            } else {
                node.setNext(head_);
                head_.setPrev(node);
                head_ = node;
            }

            size_++;
            return;
        }

        /**
         * @brief Places a new Node at the back of the list
         * 
         * @param data 
         */
        void push_back(T data) {
            Node<T>* node = new Node<T>(data);

            if (tail_ == NULL) {
                head_ = node;
                tail_ = node;
            } else {
                node.setPrev(tail_);
                tail_.setNext(node);
                tail_ = node;
            }

            size_++;
            return;
        }

        /**
         * @brief Inserts a new Node at the specified index
         * 
         * @param index 
         * @param data 
         */
        void insert(int index, T data) {
            if (index < 0 || index > size_) {
                return;
            }

            if (index == 0) {
                push_front(data);
                return;
            } else if (index == size_) {
                push_back(data);
                return;
            }

            Node<T>* node = new Node<T>(data);
            Node<T>* curr = head_;

            for (int i = 0; i < index; i++) {
                curr = curr.next();
            }

            node.setNext(curr);
            node.setPrev(curr.prev());
            curr.prev().setNext(node);
            curr.setPrev(node);

            size_++;
            return;
        }

        /**
         * @brief Removes the Node at the front of the list
         * 
         */
        void pop_front() {
            if (head_ == NULL) {
                return;
            }

            Node<T>* node = head_;
            head_ = head_.next();
            delete node;

            if (head_ == NULL) {
                tail_ = NULL;
            } else {
                head_.setPrev(NULL);                
            }

            size_--;
            return;
        }

        /**
         * @brief Removes the Node at the back of the list
         * 
         */
        void pop_back() {
            if (tail_ == NULL) {
                return;
            }

            Node<T>* node = tail_;
            tail_ = tail_.prev();
            delete node;

            if (tail_ == NULL) {
                head_ = NULL;
            } else {
                tail_.setNext(NULL);
            }

            size_--;
            return;
        }

        /**
         * @brief Removes the Node at the specified index
         * 
         * @param index 
         */
        void remove(int index) {
            if (index < 0 || index >= size_) {
                return;
            }

            if (index == 0) {
                pop_front();
                return;
            } else if (index == size_ - 1) {
                pop_back();
                return;
            }

            Node<T>* curr = head_;

            for (int i = 0; i < index; i++) {
                curr = curr.next();
            }

            curr.prev().setNext(curr.next());
            curr.next().setPrev(curr.prev());
            delete curr;

            size_--;
            return;
        }

        /**
         * @brief Removes a node from the list if the predicate
         * function returns true
         * 
         * @param predicate_function 
         */
        void remove(predicate predicate_function) {
            Node<T>* curr = head_;

            while (curr != NULL) {
                T data = curr.data();
                if (predicate_function(data)) {
                    if (curr == head_) {
                        pop_front();
                        curr = head_;
                    } else if (curr == tail_) {
                        pop_back();
                        curr = NULL;
                    } else {
                        Node<T>* next = curr.next();
                        curr.prev().setNext(next);
                        next.setPrev(curr.prev());
                        delete curr;
                        curr = next;
                    }

                    size_--;
                } else {
                    curr = curr.next();
                }
            }

            return;
        }

        /**
         * @brief Returns the data stored in the Node at the
         * specified index
         * 
         * @param index 
         * @return T 
         */
        T at(int index) const {
            if (index < 0 || index >= size_) {
                return NULL;
            }

            Node<T>* curr = head_;

            for (int i = 0; i < index; i++) {
                curr = curr.next();
            }

            return curr.data();
        }

        /**
         * @brief Returns a pointer to the head of the list
         * 
         * @return Node<T>* 
         */
        Node<T>* head() const { return head_; }

        /**
         * @brief Returns a pointer to the tail of the list
         * 
         * @return Node<T>* 
         */
        Node<T>* tail() const { return tail_; }

        /**
         * @brief Checks if the list contains a Node with the
         * specified data
         * 
         * @param data 
         * @return bool
         */
        bool contains(T data) const {
            Node<T>* curr = head_;

            while (curr != NULL) {
                if (curr.data() == data) {
                    return true;
                }

                curr = curr.next();
            }

            return false;
        }

        /**
         * @brief Checks if the list contains a Node that
         * satisfies the predicate function
         * 
         * @param predicate_function 
         * @return bool
         */
        bool contains(predicate predicate_function) const {
            Node<T>* curr = head_;

            while (curr != NULL) {
                T data = curr.data();
                if (predicate_function(data)) {
                    return true;
                }

                curr = curr.next();
            }

            return false;
        }
        
    private:
        Node<T>* head_;
        Node<T>* tail_;
        int size_;
};

#endif