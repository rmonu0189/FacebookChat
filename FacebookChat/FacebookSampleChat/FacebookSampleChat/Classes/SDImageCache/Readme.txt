{\rtf1\ansi\ansicpg1252\cocoartf1187\cocoasubrtf400
{\fonttbl\f0\fnil\fcharset0 Menlo-Regular;}
{\colortbl;\red255\green255\blue255;\red100\green56\blue32;\red28\green0\blue207;\red170\green13\blue145;
\red92\green38\blue153;\red46\green13\blue110;}
\paperw11900\paperh16840\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\deftab529
\pard\tx529\pardeftab529\pardirnatural

\f0\fs22 \cf2 \CocoaLigature0 \
// define cash size on disk\
\
#define cacheSizeMemory   \cf3 10\cf2 *\cf3 1024\cf2 *\cf3 1024\cf2 \
#define cacheSizeDisk     \cf3 10\cf2 *\cf3 1024\cf2 *\cf3 1024\
\
\
\cf2 // Get current size of folder\
\
\pard\tx529\pardeftab529\pardirnatural
\cf4 inline\cf0  \cf4 static\cf0  \cf4 unsigned\cf0  \cf4 long\cf0  \cf4 long\cf0  \cf4 int\cf0  folderSize(\cf5 NSString\cf0  *folderPath)\
\{\
    \cf5 NSArray\cf0  *filesArray = [[\cf5 NSFileManager\cf0  \cf6 defaultManager\cf0 ] \cf6 subpathsOfDirectoryAtPath\cf0 :folderPath \cf6 error\cf0 :\cf4 nil\cf0 ];\
    \cf5 NSEnumerator\cf0  *filesEnumerator = [filesArray \cf6 objectEnumerator\cf0 ];\
    \cf5 NSString\cf0  *fileName;\
    \cf4 unsigned\cf0  \cf4 long\cf0  \cf4 long\cf0  \cf4 int\cf0  fileSize = \cf3 0\cf0 ;\
    \cf4 while\cf0  (fileName = [filesEnumerator \cf6 nextObject\cf0 ]) \{\
        \cf5 NSDictionary\cf0  *fileDictionary = [[\cf5 NSFileManager\cf0  \cf6 defaultManager\cf0 ] \cf6 attributesOfItemAtPath\cf0 :[folderPath \cf6 stringByAppendingPathComponent\cf0 :fileName] \cf6 error\cf0 :\cf4 nil\cf0 ];\
        fileSize += [fileDictionary \cf6 fileSize\cf0 ];\
    \}\
    \cf4 return\cf0  fileSize;\
\}}