//
//  Random.cpp
//  WeekTen
//
//  Created by Spencer Salazar on 4/4/16.
//  Copyright © 2016 Spencer Salazar. All rights reserved.
//

#include "Random.h"
#include <stdlib.h>
#include <time.h>

static Random g_random;

const float RANDOM_MAX = 2147483647;

Random::Random()
{
    srandom(time(NULL));
}

float Random::unit()
{
    return random()/RANDOM_MAX;
}

float Random::range(float min, float max)
{
    return unit()*(max-min)+min;
}

