//
//  CircularBuffer.cpp
//  WeekNine
//
//  Created by Spencer Salazar on 4/4/16.
//  Copyright © 2016 Spencer Salazar. All rights reserved.
//

#include "CircularBuffer.h"
#include <stdlib.h>


//-----------------------------------------------------------------------------
// name: SMCircularBuffer()
// desc: constructor
//-----------------------------------------------------------------------------
FastCircularBuffer::FastCircularBuffer()
{
    m_data = NULL;
    m_data_width = m_read_offset = m_write_offset = m_max_elem = 0;
}




//-----------------------------------------------------------------------------
// name: ~SMCircularBuffer()
// desc: destructor
//-----------------------------------------------------------------------------
FastCircularBuffer::~FastCircularBuffer()
{
    this->cleanup();
}




//-----------------------------------------------------------------------------
// name: initialize()
// desc: initialize
//-----------------------------------------------------------------------------
unsigned long FastCircularBuffer::initialize( unsigned long num_elem, unsigned long width )
{
    // cleanup
    cleanup();
    
    // allocate
    m_data = (char *)malloc( num_elem * width );
    if( !m_data )
        return false;
    
    m_data_width = width;
    m_read_offset = 0;
    m_write_offset = 0;
    m_max_elem = num_elem;
    
    return true;
}




//-----------------------------------------------------------------------------
// name: cleanup()
// desc: cleanup
//-----------------------------------------------------------------------------
void FastCircularBuffer::cleanup()
{
    if( !m_data )
        return;
    
    free( m_data );
    
    m_data = NULL;
    m_data_width = m_read_offset = m_write_offset = m_max_elem = 0;
}

