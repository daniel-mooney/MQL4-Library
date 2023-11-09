#ifndef LINKED_LIST_HPP
#define LINKED_LIST_HPP

#include <MQL4Library/DataStructures/Node.mqh>

template <typename T>
class LinkedList {
    public:
        /**
         * @brief Predicate function used for identifying nodes
         * 
         */
        typedef bool (*predicate)(T);

        /**
         * @brief Construct a new Linked List object
         * @note The head and tail pointers should be initialized
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
         * @brief Places a new node at the front of the list
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
         * @brief Places a new node at the back of the list
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
         * @brief Inserts a new node at the specified index
         * 
         * @param index 
         * @param data 
         * 
         * @return true if the node was inserted
         */
        bool insert(int index, T data) {
            if (index < 0 || index > size_) {
                return false;
            }

            if (index == 0) {
                push_front(data);
                return true;
            } else if (index == size_) {
                push_back(data);
                return true;
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
            return true;
        }

        /**
         * @brief Removes the first node in the list
         * 
         */
        void pop_front() {
            if (head_ == NULL) {
                return;
            }

            Node<T>* next = head_.next();
            delete head_;
            head_ = next;

            if (head_ == NULL) {
                tail_ = NULL;
            } else {
                head_.setPrev(NULL);
            }

            size_--;
            return;
        }

        /**
         * @brief Removes the last node in the list
         * 
         */
        void pop_back() {
            if (tail_ == NULL) {
                return;
            }

            Node<T>* prev = tail_.prev();
            delete tail_;
            tail_ = prev;

            if (tail_ == NULL) {
                head_ = NULL;
            } else {
                tail_.setNext(NULL);
            }

            size_--;
            return;
        }

        /**
         * @brief Removes the node at the specified index
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
         * @brief Removes Nodes from the list that satisfy the predicate
         * 
         * @param predicate_function 
         */
        void remove(predicate predicate_function) {
            Node<T>* curr = head_;

            for (int i = 0; i < size_ && curr != NULL; i++) {
                if (predicate_function(curr.data())) {
                    if (curr == head_) {
                        pop_front();
                        curr = head_;
                    } else if (curr == tail_) {
                        pop_back();
                        curr = tail_;
                    } else {
                        curr.prev().setNext(curr.next());
                        curr.next().setPrev(curr.prev());
                        Node<T>* next = curr.next();
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
         * @brief Returns a reference to the data stored in the node
         * at the specified index
         * 
         * @param index 
         * @return T& 
         */
        T& at(int index) {
            Node<T>* curr = head_;

            for (int i = 0; i < index; i++) {
                curr = curr.next();
            }

            return curr.data();
        }

        /**
         * @brief Returns a pointer to the head node
         * 
         * @return Node<T>* 
         */
        Node<T>* getHead() { return head_; }

        /**
         * @brief Returns a pointer to the tail node
         * 
         * @return Node<T>* 
         */
        Node<T>* getTail() { return tail_; }

        bool contains(T data) {
            Node<T>* curr = head_;

            for (int i = 0; i < size_ && curr != NULL; i++) {
                if (curr.data() == data) {
                    return true;
                }

                curr = curr.next();
            }

            return false;
        }

        bool contains(predicate predicate_function) {
            Node<T>* curr = head_;

            for (int i = 0; i < size_ && curr != NULL; i++) {
                if (predicate_function(curr.data())) {
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