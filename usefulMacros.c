/* BITMANUPULATIONS */

// https: //stackoverflow.com/a/10090443
// How to extract specific bits from a number in C?
#define LAST(k,n) ((k) & ((1<<(n))-1))
#define MID(k,m,n) LAST((k)>>(m),((n)-(m)))

int main() {
    int a = 0xdeadbeef;
    printf("%x\n",  MID(a,4,16));
    return 0;
}

//To get value from specific position 'pos' to 'pos+offset' in number 'value'
#define bitGet(value, offset, pos) (((1ull << offset) - 1) & (value >> (pos - 1)))
//Set value 'newval' from position 'pos' to 'pos+offset' in number 'value'
#define bitSet(value, offset, pos, newval) \
    (~(((1ull << offset) - 1) << (pos - 1)) & value) | ((((1ull << offset) - 1) & newval) << (pos - 1))

//https: //aticleworld.com/macros-for-bit-manipulation-c-cpp/
//Macro to set nth-bit
/* 
Set single bit at pos to '1' by generating a mask
in the proper bit location and ORing (|) x with the mask. 
*/
#define SET_BIT(x, pos) (x |= (1U << pos))

//Macro to clear nth-bit
/* 
Set single bit at pos to '0' by generating a mask
in the proper bit location and Anding x with the mask. 
*/
#define CLEAR_BIT(x, pos) (x &= (~(1U << pos)))

//Macro to toggle nth-bit
/*
Set single bit at pos to '1' by generating a mask
in the proper bit location and ex-ORing x with the mask. 
*/
#define TOGGLE_BIT(x, pos) x ^= (1U << pos)

//Macro to check nth-bit
/*
Set single bit at pos to '1' by generating a mask
in the proper bit location and Anding x with the mask.
It evaluates 1 if a bit is set otherwise 0.
*/
#define CHECK_BIT(x, pos) (x & (1UL << pos))

//Macro to Get bit from the given position

#define GET_BITS(x, pos) ((x & (1 << pos)) >> pos)


/* String */
//https://gcc.gnu.org/onlinedocs/cpp/Stringizing.html
/*If you want to stringize the result of expansion of a macro argument, you have to use two levels of macros.
*/
#define xstr(s) str(s)
#define str(s) #s
#define foo 4
str(foo)
     → "foo" xstr(foo)
     → xstr(4)
     → str(4)
     → "4"

// https: //github.com/ramdeoshubham/macros/blob/master/macros.h
#define TRUE 1
#define FALSE 0

                                                                      /* Identifier */

#define AND &&
#define OR ||
#define NOT !
#define NOTEQUALS !=
#define EQUALS ==
#define IS =

#define FOREVER for (;;)
#define RANGE(i, y, x) for (i = (y); (((x) >= (y)) ? (i <= (x)) : (i >= x)); \
                            (((x) >= (y)) ? ((i)++) : ((i)--)))
#define FOREACH(i, A)                         \
    for (int _keep = 1,                       \
             _count = 0,                      \
             _size = sizeof(A) / sizeof *(A); \
         _keep && _count != _size;            \
         _keep = !_keep, _count++)            \
        for (i = (A) + _count; _keep; _keep = !_keep)

#define SWAP(a, b) \
    do             \
    {              \
        a ^= b;    \
        b ^= a;    \
        a ^= b;    \
    } while (0)
#define SORT(a, b)          \
    do                      \
    {                       \
        if ((a) > (b))      \
            SWAP((a), (b)); \
    } while (0)
#define COMPARE(x, y) (((x) > (y)) - ((x) < (y)))
#define SIGN(x) COMPARE(x, 0)
#define IS_ODD(num) ((num)&1)
#define IS_EVEN(num) (!IS_ODD((num)))
#define IS_BETWEEN(n, L, H) ((unsigned char)((n) >= (L) && (n) <= (H)))
/* STRINGS */
#define CAT(str1, str2) (str1 "" str2)

/* DEBUGGING */

#define LOG(x, fmt, ...)                         \
    if (x)                                       \
    {                                            \
        printf("%s:%d: " fmt "\n",               \
               __FILE__, __LINE__, __VA_ARGS__); \
    }
#define TRY(x, s)                                  \
    if (!(x))                                      \
    {                                              \
        printf("%s:%d:%s", __FILE__, __LINE__, s); \
    }
/*you have to  #define DEBUG to enable ASSERT*/
#ifndef DEBUG
#define ASSERT(n)
#else
#define ASSERT(n)                         \:w!

    if (!(n))                             \
    {                                     \
        printf("%s - Failed ", #n);       \
        printf("On %s ", __DATE__);       \
        printf("At %s ", __TIME__);       \
        printf("In File %s ", __FILE__);  \
        printf("At Line %d\n", __LINE__); \
        return (-1);                      \
    }
#endif

#ifdef __cplusplus
#define EXTERN_C_START \
    extern "C"         \
    {
#define EXTERN_C_END }
#else
#define EXTERN_C_START
#define EXTERN_C_END
#endif

/* Exit program */
#define DIE exit(0)

    //https : //www.cs.yale.edu/homes/aspnes/pinewiki/C(2f)Macros.html
#include <stdio.h>
 
 #define Warning(...) fprintf(stderr, __VA_ARGS__)

            int main(int argc, char **argv)
 {
     Warning("%s: this program contains no useful code\n", argv[0]);
     
     return 1;
 }

 //https://stackoverflow.com/questions/653839/what-are-c-macros-useful-for
#define BIT(x) (1 << (x))

 /* Compare strings */
#define STRCMP(A, o, B) (strcmp((A), (B)) o 0)

 /* Compare memory */
#define MEMCMP(A, o, B) (memcmp((A), (B)) o 0)