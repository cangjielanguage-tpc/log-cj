/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2023. All rights reserved.
 */

/**
 * @file
 * An optionally-bounded blocking queue based on linked nodes. This queue orders elements FIFO (first-in-first-out). T
 */
package utils

from std import sync.*
from std import math.*

public class Node<E> {
    Node(var item!: E, var next!: ?Node<E>) {}
}

public class LinkedBlockingQueue<E> {
    /** The capacity bound, or Integer.MAX_VALUE if none */
    private var capacity: Int64

    /** Current number of elements */
    private let count = AtomicInt64(0);

    /**
     * Head of linked list.
     * Invariant: head.item == null
     */
    private var head: ?Node<E> = None

    /**
     * Tail of linked list.
     * Invariant: last.next == null
     */
    private var last: ?Node<E> = None

    /** Lock held by take, poll, etc */
    private let takeLock = Monitor();

    /** Lock held by put, offer, etc */
    private let putLock = Monitor();

    public init() {
        this.capacity = Int64.Max
        last = None
        head = last
    }

    /**
       Creates a LinkedBlockingQueue with the given (fixed) capacity.
       Params:
       capacity – the capacity of this queue
       Throws:
       IllegalArgumentException – if capacity is not greater than zero
     * */
    public init(capacity: Int64) {
        if (capacity <= 0) {
            throw IllegalArgumentException()
        }
        this.capacity = capacity
        last = None
        head = last
    }

    /**
     * Signals a waiting take. Called only from put/offer (which do not
     * otherwise ordinarily lock takeLock.)
     */
    private func signalNotEmpty() {
        takeLock.lock();
        try {
            takeLock.notify();
        } finally {
            takeLock.unlock();
        }
    }

    /**
     * Signals a waiting put. Called only from take/poll.
     */
    private func signalNotFull() {
        putLock.lock();
        try {
            putLock.notify();
        } finally {
            putLock.unlock();
        }
    }

    /**
     * Links node at end of queue.
     *
     * @param node the node
     */
    private func enqueue(node: Node<E>) {
        // assert putLock.isHeldByCurrentThread();
        // assert last.next == null;
        let last = this.last
        this.last = node
        match (last) {
            case Some(v) => v.next = node
            case _ => this.head = node
        }
    }

    /**
     * Removes a node from head of queue.
     *
     * @return the node
     */
    private func dequeue(): E {
        // assert takeLock.isHeldByCurrentThread();
        // assert head.item == null;
        match (head) {
            case Some(v) => return unlinkFirst(v)
            case _ => throw IndexOutOfBoundsException()
        }
    }

    private func unlinkFirst(x: Node<E>): E {
        let element = x.item
        let next = x.next
        x.next = None
        this.head = next
        match (next) {
            case Some(v) => ()
            case _ => last = None
        }
        return element
    }

    /**
     * Locks to prevent both puts and takes.
     */
    func fullyLock() {
        putLock.lock();
        takeLock.lock();
    }

    /**
     * Unlocks to allow both puts and takes.
     */
    func fullyUnlock() {
        takeLock.unlock();
        putLock.unlock();
    }

    /**
     * Returns the number of elements in this queue.
     *
     * @return the number of elements in this queue
     */
    public func size() {
        return count.load();
    }

    /**
     * Returns the number of additional elements that this queue can ideally
     * (in the absence of memory or resource constraints) accept without
     * blocking. This is always equal to the initial capacity of this queue
     * less the current {@code size} of this queue.
     *
     * <p>Note that you <em>cannot</em> always tell if an attempt to insert
     * an element will succeed by inspecting {@code remainingCapacity}
     * because it may be the case that another thread is about to
     * insert or remove an element.
     */
    public func remainingCapacity() {
        return capacity - count.load()
    }

    /**
     * Inserts the specified element at the tail of this queue, waiting if
     * necessary for space to become available.
     *
     * @throws InterruptedException {@inheritDoc}
     * @throws NullPointerException {@inheritDoc}
     */
    public func put(e: E) {
        // Note: convention in all put/take/etc is to preset local var
        // holding count negative to indicate failure unless set.
        var c = -1;
        let newNode = Node(item: e, next: None)
        putLock.lock();
        try {
            /*
             * Note that count is used in wait guard even though it is
             * not protected by lock. This works because count can
             * only decrease at this point (all other puts are shut
             * out by lock), and we (or some other waiting put) are
             * signalled if it ever changes from capacity. Similarly
             * for all other uses of count in other wait guards.
             */
            while (count.load() == capacity) {
                putLock.wait();
            }
            enqueue(newNode);
            c = count.fetchAdd(1)
            if (c + 1 < capacity) {
                putLock.notify();
            }
        } finally {
            putLock.unlock();
        }
        if (c == 0) {
            signalNotEmpty();
        }
    }

    /**
     * Inserts the specified element at the tail of this queue if it is
     * possible to do so immediately without exceeding the queue's capacity,
     * returning {@code true} upon success and {@code false} if this queue
     * is full.
     * When using a capacity-restricted queue, this method is generally
     * preferable to method {@link BlockingQueue#add add}, which can fail to
     * insert an element only by throwing an exception.
     *
     * @throws NullPointerException if the specified element is null
     */
    public func offer(e: E): Bool {
        if (count.load() == capacity) {
            return false;
        }
        var c = -1;
        let newNode = Node(item: e, next: None)
        putLock.lock();
        try {
            if (count.load() < capacity) {
                enqueue(newNode);
                c = count.fetchAdd(1)
                if (c + 1 < capacity) {
                    putLock.notify();
                }
            }
        } finally {
            putLock.unlock();
        }
        if (c == 0) {
            signalNotEmpty();
        }
        return c >= 0
    }

    /**
     * Return and remove the element at the front of the queue
     */
    public func poll(): Option<E> {
        if (count.load() == 0) {
            return None<E>
        }
        var x = None<E>
        var c = -1;
        takeLock.lock();
        try {
            if (count.load() > 0) {
                x = dequeue()
                c = count.fetchSub(1)
                if (c > 1) {
                    takeLock.notify();
                }
            }
        } finally {
            takeLock.unlock();
        }
        if (c == capacity) {
            signalNotFull();
        }
        return x
    }

    /**
     * Return the element at the front of the queue
     */
    public func peek(): Option<E> {
        if (count.load() == 0) {
            return None<E>
        }
        takeLock.lock();
        try {
            var head = this.head
            match (head) {
                case Some(v) => return v.item
                case _ => return None<E>
            }
        } finally {
            takeLock.unlock();
        }
    }

    /**
     * Atomically removes all of the elements from this queue.
     * The queue will be empty after this call returns.
     */
    public func clear() {
        fullyLock();
        try {
            last = None
            head = last

            // assert head.item == null && head.next == null;
            count.store(0)
            if (count.load() == capacity) {
                putLock.notify();
            }
        } finally {
            fullyUnlock();
        }
    }
}
