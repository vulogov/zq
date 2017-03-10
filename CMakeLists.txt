CMAKE_MINIMUM_REQUIRED( VERSION 2.8.5 )

PROJECT( ZQ  )

# Make the scripts available in the 'cmake' directory available for the
# 'include()' command, 'find_package()' command.
SET( CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_SOURCE_DIR}/cmake )
SET( PYTHON_INCLUDE_DIRS ${PYTHON_INCLUDE_DIRS} ${CMAKE_SOURCE_DIR}/include )


INCLUDE( UseCython )
INCLUDE( zq )

ADD_CUSTOM_TARGET( ReplicatePythonSourceTree ALL ${CMAKE_COMMAND} -P
  ${CMAKE_CURRENT_SOURCE_DIR}/cmake/ReplicatePythonSourceTree.cmake
  ${CMAKE_CURRENT_BINARY_DIR}
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} )


INCLUDE_DIRECTORIES( ${CYTHON_CMAKE_EXAMPLE_SOURCE_DIR}/include )

ENABLE_TESTING()
FIND_FILE( NOSETESTS_EXECUTABLE nosetests )
ADD_TEST( nosetests "${NOSETESTS_EXECUTABLE}" -v --with-xunit )


ADD_SUBDIRECTORY( zq )







