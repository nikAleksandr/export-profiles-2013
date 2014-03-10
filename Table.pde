class Table {
  String[][] data;

  
  int rowCount;
  
  
  Table() {
    data = new String[10][10];
    
  }

  
  Table(String filename) {
    String[] rows = loadStrings(filename);
    data = new String[rows.length][];
   
    
    for (int i = 0; i < rows.length; i++) {
      if (trim(rows[i]).length() == 0) {
        continue; // skip empty rows
      }
      if (rows[i].startsWith("#")) {
        continue;  // skip comment lines
      }
      
      // split the row on the tabs
      String[] pieces = split(rows[i], '\t');
      scrubQuotes(pieces);
      // copy to the table array
      data[rowCount] = pieces;

      
      
      rowCount++;
      
      // this could be done in one fell swoop via:
      //data[rowCount++] = split(rows[i],'\t');
    }
    // resize the 'data' array as necessary
    data = (String[][]) subset(data, 0, rowCount);
  }




   void scrubQuotes(String[] array) {
    for (int i = 0; i < array.length; i++) {
      if (array[i].length() > 2) {
        // remove quotes at start and end, if present
        if (array[i].startsWith("\"") && array[i].endsWith("\"")) {
          array[i] = array[i].substring(1, array[i].length() - 1);
        }
      }
      // make double quotes into single quotes
      array[i] = array[i].replaceAll("\"\"", "\"");
      array[i] = trim(array[i]);
    }
  }

  int getRowCount() {
    return rowCount;
  }
  
  
  // find a row by its name, returns -1 if no row found
  int getRowIndex(String name) {
    for (int i = 0; i < rowCount; i++) {
      if (data[i][0].equals(name)) {
        return i;
      }
    }
    println("No row named '" + name + "' was found");
    return -1;
  }
  
  
  String getRowName(int row) {
    return getString(row, 0);
  }


  String getString(int rowIndex, int column) {
    return data[rowIndex][column];
  }

  
  String getString1(String rowName, int column) {
    return getString(getRowIndex(rowName), column);
  }

  
  int getInt(String rowName, int column) {
    return parseInt(getString1(rowName, column));
  }

  
  int getInt1(int rowIndex, int column) {
    return parseInt(getString(rowIndex, column));
  }

  
  float getFloat(String rowName, int column) {
    return parseFloat(getString1(rowName, column));
  }

//only count up to second to last row: world value is last row and shouldn't be included
float getColumnMin(int col) {
    float m = MAX_FLOAT;
    for (int i = 0; i < rowCount-1; i++) {
      // if (!Float.isNaN(data[i][col])) {
      if (parseFloat(data[i][col]) < m) {
        m = parseFloat(data[i][col]);
      }
      //}
    }
    return m;
  }


  float getColumnMax(int col) {
    float m = -MAX_FLOAT;
    for (int i = 0; i < rowCount-1; i++) {
      // if (isValid(i, col)) {
      if (parseFloat(data[i][col]) > m) {
        m = parseFloat(data[i][col]);
      }
      // }
    }
    return m;
  }


  
  float getFloat1(int rowIndex, int column) {
    return parseFloat(getString(rowIndex, column));
  }
  
  
  void setRowName(int row, String what) {
    data[row][0] = what;
  }


  void setString(int rowIndex, int column, String what) {
    data[rowIndex][column] = what;
  }
  

  

  
  void setString1(String rowName, int column, String what) {
    int rowIndex = getRowIndex(rowName);
    data[rowIndex][column] = what;
  }

  
  void setInt(int rowIndex, int column, int what) {
    data[rowIndex][column] = str(what);
  }

  
  void setInt1(String rowName, int column, int what) {
    int rowIndex = getRowIndex(rowName);
    data[rowIndex][column] = str(what);
  }

  
  void setFloat(int rowIndex, int column, float what) {
    data[rowIndex][column] = str(what);
  }


  void setFloat1(String rowName, int column, float what) {
    int rowIndex = getRowIndex(rowName);
    data[rowIndex][column] = str(what);
  }
  
   void write(PrintWriter writer) {
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < data[i].length; j++) {
        if (j != 0) {
          writer.print(TAB);
        }
        if (data[i][j] != null) {
          writer.print(data[i][j]);
        }
      }
      writer.println();
    }
    writer.flush();
  }
  
  
  

}
