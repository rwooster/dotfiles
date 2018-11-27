import os

HOMEDIR = os.getenv('HOME')

# If you ever have problems with a file (noticing false-positives or
# false-negatives), debug by running
#
# $ clang++-7 -c $(python path-to-this-file) file-youre-having-trouble-with.cc
#
def FlagsForFile(filename, **kwargs):
  # Note that the standard library include directories can be obtained with:
  #   $ echo | clang++-7 -v -E -x c++ -std=c++14 -
  flags = {
    'flags': [ '-x', 'c++', '-std=c++14', '-Wall', '-fopenmp',
               # everything in 'src' (including 'third-party')
               '-I%s/driving/src' % HOMEDIR,
               # boost
               '-DBOOST_ASIO_ENABLE_OLD_SERVICES',
               '-DBOOST_ENABLE_ASSERT_HANDLER',

               '-isystem', '%s/driving/src/bazel-src/external/boost/boost_1_67_0' % HOMEDIR,
               # tdl
               '-I%s/driving/src/bazel-src/external/tdl' % HOMEDIR,
               # tdl third-party (sophus)
               '-I%s/driving/src/bazel-src/external/tdl/third_party/sophus/Sophus' % HOMEDIR,
               # drake
               '-I%s/driving/src/bazel-src/external/drake' % HOMEDIR,
               # galeru
               '-I%s/driving/src/bazel-src/external' % HOMEDIR,
               # eigen
               '-isystem', '%s/driving/src/bazel-src/external/eigen' % HOMEDIR,
               # ceres
               '-isystem', '%s/driving/src/bazel-src/external/ceres/include' % HOMEDIR,

               # opencv
               '-isystem', '%s/driving/src/bazel-src/external/opencv/modules/calib3d/include' % HOMEDIR,
               '-isystem', '%s/driving/src/bazel-src/external/opencv/modules/core/include' % HOMEDIR,
               '-isystem', '%s/driving/src/bazel-src/external/opencv/modules/features2d/include' % HOMEDIR,
               '-isystem', '%s/driving/src/bazel-src/external/opencv/modules/highgui/include' % HOMEDIR,
               '-isystem', '%s/driving/src/bazel-src/external/opencv/modules/imgcodecs/include' % HOMEDIR,
               '-isystem', '%s/driving/src/bazel-src/external/opencv/modules/imgproc/include' % HOMEDIR,
               '-isystem', '%s/driving/src/bazel-src/external/opencv/modules/ml/include' % HOMEDIR,
               '-isystem', '%s/driving/src/bazel-src/external/opencv/modules/videoio/include' % HOMEDIR,
               # More opencv modules go here (as needed).

               # opencv includes a cmake-generated header that doesn't exist in
               # our bazel-based project.
               '-isystem', '%s/workaround-include' % os.path.dirname(os.path.realpath(__file__)),

               # standard c++ library
               '-isystem', '/usr/bin/../lib/gcc/x86_64-linux-gnu/5.4.0/../../../../include/c++/5.4.0',
               '-isystem', '/usr/bin/../lib/gcc/x86_64-linux-gnu/5.4.0/../../../../include/x86_64-linux-gnu/c++/5.4.0',
               '-isystem', '/usr/bin/../lib/gcc/x86_64-linux-gnu/5.4.0/../../../../include/c++/5.4.0/backward',
               '-isystem', '/usr/include/clang/7.0.0/include',

               # system-wide includes
               '-isystem', '/usr/local/include',
               '-isystem', '/usr/include/x86_64-linux-gnu',
               '-isystem', '/usr/include',
               '-isystem', '/usr/include/python3.5m',
    ],
  }

  # QT is kind of a pain. We need to include generated files...
  flags['flags'].append('-I%s/driving/src/bazel-genfiles/' % HOMEDIR)

  # ...and a bunch of qt5 dirs.
  for dirpath, dirnames, _ in os.walk('/usr/include/x86_64-linux-gnu/qt5'):
    flags['flags'].append('-isystem')
    flags['flags'].append(os.path.join(dirpath))
    for dirname in dirnames:
      flags['flags'].append('-isystem')
      flags['flags'].append(os.path.join(dirpath, dirname))
    break
  return flags

if __name__ == '__main__':
  print(' '.join(FlagsForFile('.')['flags']))

