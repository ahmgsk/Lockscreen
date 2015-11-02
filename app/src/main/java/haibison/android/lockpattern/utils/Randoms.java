/*
 *   Copyright 2012 Hai Bison
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 */

package haibison.android.lockpattern.utils;

import android.support.annotation.NonNull;

import java.util.List;
import java.util.Random;

import haibison.android.lockpattern.collect.Lists;

/**
 * Random utilities.
 *
 * @author Hai Bison
 */
public class Randoms {

    private static final Random RANDOM = new Random();

    /**
     * This is singleton class.
     */
    private Randoms() {
    }// Random()

    /**
     * Generates a random integer.
     *
     * @return the random integer.
     */
    public static int i() {
        return RANDOM.nextInt((int) (System.nanoTime() % Integer.MAX_VALUE));
    }//i()

    /**
     * Generates a random integer within {@code [0, n)}.
     *
     * @param n an arbitrary value.
     * @return the random integer.
     */
    public static int i(int n) {
        return n > 0 ? i() % n : 0;
    }//i()

    /**
     * Generates a random integer array which has length of {@code end - start}, and is filled by all values from {@code start} to {@code
     * end - 1} in randomized orders.
     *
     * @param start the starting value.
     * @param end   the ending value.
     * @return the random integer array. If {@code end <= start}, an empty array returns.
     */
    @NonNull
    public static int[] intArray(int start, int end) {
        if (end <= start) return new int[0];

        final List<Integer> values = Lists.newArrayList();
        for (int i = start; i < end; i++) values.add(i);

        final int[] result = new int[values.size()];
        for (int i = 0; i < result.length; i++) {
            int k = i(values.size());
            result[i] = values.get(k);
            values.remove(k);
        }// for

        return result;
    }//intArray()

    /**
     * Generates a random integer array which has length of {@code end}, and is filled by all values from {@code 0} to {@code end - 1} in
     * randomized orders.
     *
     * @param end the ending value.
     * @return the random integer array. If {@code end <= start}, an empty array returns.
     */
    @NonNull
    public static int[] intArray(int end) {
        return intArray(0, end);
    }//intArray()

}
