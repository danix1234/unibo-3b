/****************************************************************************
 *
 * arraySum.c -- sequential and parallel array sum
 *
 * Written in 2023 by Gianluigi Zavattaro
 * Modified in 2025 by Moreno Marzolla <moreno.marzolla(at)unibo.it>
 *
 * To the extent possible under law, the author(s) have dedicated all
 * copyright and related and neighboring rights to this software to the
 * public domain worldwide. This software is distributed without any warranty.
 *
 * You should have received a copy of the CC0 Public Domain Dedication
 * along with this software. If not, see
 * <http://creativecommons.org/publicdomain/zero/1.0/>.
 *
 * --------------------------------------------------------------------------
 *
 * Sequential and parallel solutions (some are WRONG) to the problem
 * of summing the elements in an array.
 *
 * Compile with:
 *
 *      gcc -std=c99 -Wall -Wpedantic -fopenmp arraySum.c -o arraySum
 *
 * Execute with an appropriate number of threads, e.g.
 *
 *      OMP_NUM_THREADS=6 ./arraySum 2000000
 *
 * (the optional parameter indicates the array length)
 *
 ****************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <omp.h>

// sequential version
long sum1(int* A, int n)
{
    int i;
    long result = 0;

    printf("*** SEQUENTIAL WITH COUNTER = ");

    for (i=0; i<n; i++) {
        result += A[i];
    }

    printf("%ld\n", result);
    return result;
}

// parallel but WRONG: concurrent updates of the counter
long sum2(int* A, int n)
{
    long result = 0;

    printf("*** [WRONG] PARALLEL WITH CONCURRENT UPDATES = ");

#pragma omp parallel
    {
        // by default, `result` is shared across threads
        const int my_block_len = n/omp_get_num_threads();
        const int my_start = omp_get_thread_num() * my_block_len;
        const int my_end = my_start + my_block_len;
        for (int my_i=my_start; my_i<my_end; my_i++) {
            result += A[my_i];
        }
    }

    printf("%ld\n", result);
    return result;
}

// parallel with mutex on counter but WRONG partitioning (if num_threads is not a divisor of size)
long sum3(int* A, int n)
{
    long result = 0;

    printf("*** [WRONG] PARALLEL WITH MUTEX BUT WRONG PARTITIONING = ");

#pragma omp parallel
    {
        const int my_block_len = n/omp_get_num_threads();
        const int my_start = omp_get_thread_num() * my_block_len;
        const int my_end = my_start + my_block_len;
        for (int my_i=my_start; my_i<my_end; my_i++) {
#pragma omp atomic
            result += A[my_i];
        }
    }

    printf("%ld\n", result);
    return result;
}

// parallel with mutex on counter
long sum4(int* A, int n)
{
    long result = 0;

    printf("*** PARALLEL WITH MUTEX ON COUNTER = ");

#pragma omp parallel
    {
        const int my_start = n * omp_get_thread_num() / omp_get_num_threads();
        const int my_end = n * (omp_get_thread_num()+1) / omp_get_num_threads();
        for (int my_i=my_start; my_i<my_end; my_i++) {
#pragma omp atomic
            result += A[my_i];
        }
    }

    printf("%ld\n", result);
    return result;
}

// parallel with local counters and mutex on the global counter
long sum5(int* A, int n)
{
    long result = 0;

    printf("*** PARALLEL WITH LOCAL COUNTERS AND MUTEX ON GLOBAL COUNTER = ");

#pragma omp parallel
    {
        const int my_start = n * omp_get_thread_num() / omp_get_num_threads();
        const int my_end = n * (omp_get_thread_num()+1) / omp_get_num_threads();
        long my_sum = 0;
        for (int my_i=my_start; my_i<my_end; my_i++) {
            my_sum += A[my_i];
        }
#pragma omp atomic
        result += my_sum;
    }

    printf("%ld\n", result);
    return result;
}

// parallel without mutex - WRONG without barrier synchronization
long sum6(int* A, int n)
{
    const int num_threads = omp_get_num_threads();
    const int thread_num = omp_get_thread_num();
    long psum[num_threads];
    long result = 0;

    printf("*** [WRONG] PARALLEL WITH NO MUTEX BUT WITHOUT BARRIER SYNCHRONIZATION = ");

#pragma omp parallel
    {
        const int my_start = n * thread_num / num_threads;
        const int my_end = n * (thread_num+1) / num_threads;
        long my_sum = 0;
        for (int my_i=my_start; my_i<my_end; my_i++) {
            my_sum += A[my_i];
        }
        psum[thread_num]=my_sum;
        if (thread_num==0)
            for (int i=0; i<num_threads; i++)
                result += psum[i];
    }

    printf("%ld\n", result);
    return result;
}

// parallel without mutex and with barrier synchronization
long sum7(int* A, int n)
{
    const int num_threads = omp_get_num_threads();
    const int thread_num = omp_get_thread_num();
    long psum[num_threads];
    long result = 0;

    printf("*** PARALLEL WITH NO MUTEX, WITH BARRIER SYNCHRONIZATION = ");

#pragma omp parallel
    {
        const int my_start = n * thread_num / num_threads;
        const int my_end = n * (thread_num+1) / num_threads;
        long my_sum = 0;
        for (int my_i=my_start; my_i<my_end; my_i++) {
            my_sum += A[my_i];
        }
        psum[thread_num]=my_sum;
    } // implicit barrier at the end of the parallel region
    for (int i=0; i<num_threads; i++)
        result += psum[i];

    printf("%ld\n", result);
    return result;
}

// parallel with reduction on local sums
long sum8(int* A, int n)
{
   long result = 0;

   printf("*** PARALLEL REDUCTION OF LOCAL SUMS = ");

#pragma omp parallel reduction(+:result)
    {
        const int my_start = n * omp_get_thread_num() / omp_get_num_threads();
        const int my_end = n * (omp_get_thread_num()+1) / omp_get_num_threads();
        long my_sum = 0;
        for (int my_i=my_start; my_i<my_end; my_i++) {
            my_sum += A[my_i];
        }
        result += my_sum;
    }

    printf("%ld\n", result);
    return result;
}

// parallel with global reduction
long sum9(int* A, int n)
{
    long result = 0;

    printf("*** PARALLEL REDUCTION = ");

#pragma omp parallel for reduction(+:result)
    for (int i=0; i<n; i++) {
        result += A[i];
    }

    printf("%ld\n", result);
    return result;
}

int main(int argc, char *argv[])
{
    int size;
    int *A;

    if (argc == 2)
        size = atoi(argv[1]);
    else
        size = 939391; // a prime number

    printf("\narray length = %d\n\n", size);

    A = (int*)malloc(size * sizeof(*A));
    assert(A != NULL);

    srand(17);
    for (int i=0;i<size;i++)
    	A[i] = rand()%2;

    sum1(A, size);
    sum2(A, size);
    sum3(A, size);
    sum4(A, size);
    sum5(A, size);
    sum6(A, size);
    sum7(A, size);
    sum8(A, size);
    sum9(A, size);

    free(A);
    return 0;
}
