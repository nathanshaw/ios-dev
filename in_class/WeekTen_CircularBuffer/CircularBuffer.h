//
//  CircularBuffer.hpp
//  WeekNine
//
//  Created by Spencer Salazar on 4/4/16.
//  Copyright © 2016 Spencer Salazar. All rights reserved.
//

#ifndef CircularBuffer_hpp
#define CircularBuffer_hpp

#include <stddef.h>

//-----------------------------------------------------------------------------
// name: class CircularBuffer
// desc: templated circular buffer
//-----------------------------------------------------------------------------
template<typename T>
class CircularBuffer
{
public:
    
    CircularBuffer(size_t numElements) :
    m_read(0),
    m_write(0),
    m_numElements(numElements+1) // need 1 element to pad
    {
        m_elements = new T[m_numElements];
    }
    
    ~CircularBuffer()
    {
        if(m_elements != NULL)
        {
            delete[] m_elements;
            m_elements = NULL;
        }
    }
    
    // put one element
    // returns number of elements successfully put
    size_t put(T element)
    {
        if((m_write + 1)%m_numElements == m_read)
        {
            // no space
            return 0;
        }
        
        m_elements[m_write] = element;
        
        m_write = (m_write+1)%m_numElements;
        
        return 1;
    }
    
    // get one element
    // returns number of elements successfully got
    size_t get(T &element)
    {
        if(m_read == m_write)
        {
            // nothing to get
            return 0;
        }
        
        element = m_elements[m_read];
        
        m_read = (m_read+1)%m_numElements;
        
        return 1;
    }
    
    // peek at element i without removing it
    // i = 1 would correspond to the least recently put element;
    // i = -1 would correspond to the most recent (not implemented)
    // returns 1 if elements successfully peeked
    size_t peek(T &element, size_t i)
    {
        if(i == 0)
            return 0;
        
        if(i > 0 && i <= numElements())
        {
            element = m_elements[(m_read+(i-1))%m_numElements];
            return 1;
        }
        
        return 0;
    }
    
    void clear() { m_write = m_read; }
    
    // return maximum number of elements that can be held
    size_t maxElements() { return m_numElements-1; }
    
    // return if buffer is full
    bool atMaximum() { return (m_write + 1)%m_numElements == m_read; }
    
    // return number of valid elements in the buffer
    size_t numElements()
    {
        if(m_read == m_write)
            return 0;
        else if(m_read < m_write)
            return m_write - m_read;
        else
            return m_numElements - m_read + m_write;
    }
    
private:
    T * m_elements;
    size_t m_read, m_write;
    const size_t m_numElements;
};




//-----------------------------------------------------------------------------
// name: class FastCircularBuffer
// desc: uses memcpy instead of assignment
//       useful for streaming large blocks of data
//-----------------------------------------------------------------------------
class FastCircularBuffer
{
public:
    FastCircularBuffer();
    ~FastCircularBuffer();
    
public:
    unsigned long initialize( unsigned long num_elem, unsigned long width );
    void cleanup();
    
public:
    unsigned long get( void * data, unsigned long num_elem );
    unsigned long put( void * data, unsigned long num_elem );
    inline bool hasMore() { return (m_read_offset != m_write_offset); }
    inline void clear() { m_read_offset = m_write_offset = 0; }
    
protected:
    char *m_data;
    unsigned long m_data_width;
    unsigned long m_read_offset;
    unsigned long m_write_offset;
    unsigned long m_max_elem;
};


#endif /* CircularBuffer_hpp */
