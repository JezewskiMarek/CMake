#
# This module finds if wxWindows is installed and determines where the
# include files and libraries are. It also determines what the name of
# the library is. This code sets the following variables:
#
#  WXWINDOWS_LIBRARY         = full path to the wxWindows library and linker flags on unix
#  CMAKE_WX_CXX_FLAGS        = compiler flags for building wxWindows 
#  WXWINDOWS_INCLUDE_PATH    = include path of wxWindows

IF(WIN32)

  SET (WXWINDOWS_POSSIBLE_LIB_PATHS
    $ENV{WXWIN}/lib
    "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\wxWindows_is1;Inno Setup: App Path]/lib"
  )

  FIND_LIBRARY(WXWINDOWS_STATIC_LIBRARY
    NAMES wx
    PATHS ${WXWINDOWS_POSSIBLE_LIB_PATHS} 
  )

  FIND_LIBRARY(WXWINDOWS_SHARED_LIBRARY
    NAMES wx23_2 wx22_9
    PATHS ${WXWINDOWS_POSSIBLE_LIB_PATHS} 
  )

  SET (WXWINDOWS_POSSIBLE_INCLUDE_PATHS
    $ENV{WXWIN}/include
    "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\wxWindows_is1;Inno Setup: App Path]/include"
  )

  FIND_PATH(WXWINDOWS_INCLUDE_PATH
    wx/wx.h
    ${WXWINDOWS_POSSIBLE_INCLUDE_PATHS} 
  )

  IF(WXWINDOWS_SHARED_LIBRARY)
    OPTION(WXWINDOWS_USE_SHARED_LIBS 
           "Use shared versions of wxWindows libraries" ON)
    MARK_AS_ADVANCED(WXWINDOWS_USE_SHARED_LIBS)
  ENDIF(WXWINDOWS_SHARED_LIBRARY)

  SET(CMAKE_WX_LIBRARIES ${CMAKE_WX_LIBRARIES} comctl32 ctl3d32 wsock32 rpcrt4)

  IF(WXWINDOWS_USE_SHARED_LIBS)
    SET(WXWINDOWS_LIBRARY ${WXWINDOWS_SHARED_LIBRARY} ${CMAKE_WX_LIBRARIES})
  ELSE(WXWINDOWS_USE_SHARED_LIBS)
    SET(WXWINDOWS_LIBRARY ${WXWINDOWS_STATIC_LIBRARY} ${CMAKE_WX_LIBRARIES})
  ENDIF(WXWINDOWS_USE_SHARED_LIBS)

  MARK_AS_ADVANCED(
    WXWINDOWS_STATIC_LIBRARY
    WXWINDOWS_SHARED_LIBRARY
    WXWINDOWS_INCLUDE_PATH
  )

ELSE(WIN32)

  FIND_PROGRAM(CMAKE_WX_CONFIG wx-config ../wx/bin ../../wx/bin)
  SET(CMAKE_WX_CXX_FLAGS "`${CMAKE_WX_CONFIG} --cflags`")
  SET(WXWINDOWS_LIBRARY "`${CMAKE_WX_CONFIG} --libs`")

ENDIF(WIN32)  

MARK_AS_ADVANCED(
  CMAKE_WX_CXX_FLAGS
  WXWINDOWS_INCLUDE_PATH
)

IF(WXWINDOWS_LIBRARY)
  IF(WXWINDOWS_INCLUDE_PATH OR CMAKE_WX_CXX_FLAGS)
    SET(CMAKE_WX_CAN_COMPILE 1)
  ENDIF(WXWINDOWS_INCLUDE_PATH OR CMAKE_WX_CXX_FLAGS)
ENDIF(WXWINDOWS_LIBRARY)

