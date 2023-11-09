#ifndef OBJECT_LINKED_LIST_HPP
#define OBJECT_LINKED_LIST_HPP

#include <MQL4Library/DataStructures/ObjectNode.mqh>

/**
 * @brief A linked list of objects
 * @details Objects can only be passed by reference
 * @note A copy of the reference to the object is 
 * stored in the list
 * 
 * @tparam T 
 */
template <typename T>
class ObjectLinkedList {
    public:
        /**
         * @brief Predicate function used for identifying nodes
         * 
         */
        typedef bool (*ObjectPredicate)(const T&);

        /**
         * @brief Construct a new Linked List object
         * @note The head and tail pointers should be initialized
         * to NULL and the size is initialized to 0
         * 
         */
        ObjectLinkedList() : head_(NULL), tail_(NULL), size_(0) {}

        /**
         * @brief Destroy the Linked List object
         * @note The destructor should call the clear function
         * to free all memory associated with the list
         * 
         */
        ~ObjectLinkedList() {
            ObjectNode<T>* curr = head_;

            for (int i = 0; i < size_ && curr != NULL; i++) {
                ObjectNode<T>* next = curr.next();
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
         * @brief Places a new ObjectNode at the front of the list
         * 
         * @param data 
         */
        void push_front(T& data) {
            ObjectNode<T>* node = new ObjectNode<T>(data);

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
         * @brief Places a new ObjectNode at the back of the list
         * 
         * @param data 
         */
        void push_back(T& data) {
            ObjectNode<T>* node = new ObjectNode<T>(data);

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
         * @brief Inserts a new ObjectNode at the specified index
         * 
         * @param index 
         * @param data 
         * 
         * @return true if the ObjectNode was inserted
         */
        void insert(int index, T& data) {
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

            ObjectNode<T>* node = new ObjectNode<T>(data);
            ObjectNode<T>* curr = head_;

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
         * @brief Removes the first ObjectNode in the list
         * 
         */
        void pop_front() {
            if (head_ == NULL) {
                return;
            }

            ObjectNode<T>* next = head_.next();
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
         * @brief Removes the last ObjectNode in the list
         * 
         */
        void pop_back() {
            if (tail_ == NULL) {
                return;
            }

            ObjectNode<T>* prev = tail_.prev();
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
         * @brief Removes the ObjectNode at the specified index
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

            ObjectNode<T>* curr = head_;

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
         * @brief Removes Nodes from the list that satisfy the ObjectPredicate
         * 
         * @param predicate_function 
         */
        void remove(ObjectPredicate predicate_function) {
            ObjectNode<T>* curr = head_;

            for (int i = 0; i < size_ && curr != NULL; i++) {
                T data = *curr.data();
                if (predicate_function(data)) {
                    if (curr == head_) {
                        pop_front();
                        curr = head_;
                    } else if (curr == tail_) {
                        pop_back();
                        curr = tail_;
                    } else {
                        curr.prev().setNext(curr.next());
                        curr.next().setPrev(curr.prev());
                        ObjectNode<T>* next = curr.next();
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
         * @brief Returns a reference to the data stored in the ObjectNode
         * at the specified index
         * 
         * @param index 
         * @return T& 
         */
        T* at(int index) {
            ObjectNode<T>* curr = head_;

            for (int i = 0; i < index; i++) {
                curr = curr.next();
            }

            return curr.data();
        }

        /**
         * @brief Returns a pointer to the head ObjectNode
         * 
         * @return ObjectNode<T>* 
         */
        ObjectNode<T>* head() { return head_; }

        /**
         * @brief Returns a pointer to the tail ObjectNode
         * 
         * @return ObjectNode<T>* 
         */
        ObjectNode<T>* tail() { return tail_; }

        bool contains(T& data) {
            ObjectNode<T>* curr = head_;

            for (int i = 0; i < size_ && curr != NULL; i++) {
                if ((*curr.data()) == data) {
                    return true;
                }

                curr = curr.next();
            }

            return false;
        }

        bool contains(ObjectPredicate predicate_function) {
            ObjectNode<T>* curr = head_;

            for (int i = 0; i < size_ && curr != NULL; i++) {
                if (predicate_function(*curr.data())) {
                    return true;
                }

                curr = curr.next();
            }

            return false;
        }

        /**
         * @brief Returns the first ObjectNode that satisfies the ObjectPredicate
         * 
         * @param predicate_function 
         * @return T* 
         */
        T* get(ObjectPredicate predicate_function) {
            ObjectNode<T>* curr = head_;

            for (int i = 0; i < size_ && curr != NULL; i++) {
                if (predicate_function(*curr.data())) {
                    return curr.data();
                }

                curr = curr.next();
            }

            return NULL;
        }

    private:
        ObjectNode<T>* head_;
        ObjectNode<T>* tail_;
        int size_;
};

#endif