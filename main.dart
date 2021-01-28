//import 'dart:convert';
import 'package:cgi_tryouts/cgi_tryouts.dart' as cgi_tryouts;
import 'dart:io';
import 'dart:async';
import 'dart:math';
//import 'package:csv/csv.dart';
//tal vez quitar los 5

final size = 5;

Future<List<List>> readFile(path) async {
  List<List> matrix = List();
  List rows;
  List<List> items = [[]];
  String str;
  str = await File(path).readAsString().then((String contents) {
    return contents;
  });
  rows = str.split('\n');
  items = rows.map((row) => row.toString().split(',')).toList();
  matrix = items.map((item) => item).toList();
  matrix.removeLast();
  //final input = File(path).openRead();
  //final fields = await input.transform(utf8.decoder).transform(CsvToListConverter()).toList();

  //print(fields[0].toString());
  return matrix;
}

Future<void> constructMatrix(path, arg1, arg2, arg3, arg4, path2) async {
  int n;
  List<List> matrix = List(size);
  double sumx1 = 0, sumx2 = 0, sumx3 = 0, sumx4 = 0,
  sumx1sq = 0, sumx2sq = 0, sumx3sq = 0, sumx4sq = 0,
  sumx1x2 = 0, sumx1x3 = 0, sumx1x4 = 0, sumx2x3 = 0, sumx2x4 = 0, sumx3x4 = 0,
  sumy = 0, sumx1y = 0, sumx2y = 0, sumx3y = 0, sumx4y = 0;
  List<List> fileContents = await readFile(path);
  n = fileContents.length;
  for(int i = 0; i < fileContents.length; i++)
    sumx1 += double.parse(fileContents[i][0]);
  for(int i = 0; i < fileContents.length; i++)
    sumx2 += double.parse(fileContents[i][1]);
  for(int i = 0; i < fileContents.length; i++)
    sumx3 += double.parse(fileContents[i][2]);
  for(int i = 0; i < fileContents.length; i++)
    sumx4 += double.parse(fileContents[i][3]);
  for(int i = 0; i < fileContents.length; i++)
    sumx1sq += pow(double.parse(fileContents[i][0]), 2);
  for(int i = 0; i < fileContents.length; i++)
    sumx2sq += pow(double.parse(fileContents[i][1]), 2);
  for(int i = 0; i < fileContents.length; i++)
    sumx3sq += pow(double.parse(fileContents[i][2]), 2);
  for(int i = 0; i < fileContents.length; i++)
    sumx4sq += pow(double.parse(fileContents[i][3]), 2);
  for(int i = 0; i < fileContents.length; i++)
    sumx1x2 += double.parse(fileContents[i][0]) * double.parse(fileContents[i][1]);
  for(int i = 0; i < fileContents.length; i++)
    sumx1x3 += double.parse(fileContents[i][0]) * double.parse(fileContents[i][2]);
  for(int i = 0; i < fileContents.length; i++)
    sumx1x4 += double.parse(fileContents[i][0]) * double.parse(fileContents[i][3]);
  for(int i = 0; i < fileContents.length; i++)
    sumx2x3 += double.parse(fileContents[i][1]) * double.parse(fileContents[i][2]);
  for(int i = 0; i < fileContents.length; i++)
    sumx2x4 += double.parse(fileContents[i][0]) * double.parse(fileContents[1][3]);
  for(int i = 0; i < fileContents.length; i++)
    sumx3x4 += double.parse(fileContents[i][2]) * double.parse(fileContents[i][3]);
  for(int i = 0; i < fileContents.length; i++)
    sumy += double.parse(fileContents[i][4]);
  for(int i = 0; i < fileContents.length; i++)
    sumx1y += double.parse(fileContents[i][0]) * double.parse(fileContents[i][4]);
  for(int i = 0; i < fileContents.length; i++)
    sumx2y += double.parse(fileContents[i][1]) * double.parse(fileContents[i][4]);
  for(int i = 0; i < fileContents.length; i++)
    sumx3y += double.parse(fileContents[i][2]) * double.parse(fileContents[i][4]);
  for(int i = 0; i < fileContents.length; i++)
    sumx4y += double.parse(fileContents[i][3]) * double.parse(fileContents[i][4]);

  for(int i = 0; i < size; i++)
    matrix[i] = List(size + 1);

  matrix[0][0] = n;
  matrix[0][1] = sumx1;
  matrix[0][2] = sumx2;
  matrix[0][3] = sumx3;
  matrix[0][4] = sumx4;
  matrix[0][5] = sumy;
  matrix[1][0] = sumx1;
  matrix[1][1] = sumx1sq;
  matrix[1][2] = sumx1x2;
  matrix[1][3] = sumx1x3;
  matrix[1][4] = sumx1x4;
  matrix[1][5] = sumx1y;
  matrix[2][0] = sumx2;
  matrix[2][1] = sumx1x2;
  matrix[2][2] = sumx2sq;
  matrix[2][3] = sumx2x3;
  matrix[2][4] = sumx2x4;
  matrix[2][5] = sumx2y;
  matrix[3][0] = sumx3;
  matrix[3][1] = sumx1x3;
  matrix[3][2] = sumx2x3;
  matrix[3][3] = sumx3sq;
  matrix[3][4] = sumx3x4;
  matrix[3][5] = sumx3y;
  matrix[4][0] = sumx4;
  matrix[4][1] = sumx1x4;
  matrix[4][2] = sumx2x4;
  matrix[4][3] = sumx3x4;
  matrix[4][4] = sumx4sq;
  matrix[4][5] = sumx4y;

  gauss(matrix);
  resolveFile(matrix, arg1, arg2, arg3, arg4, path2);
}

Future<void> resolveFile(matrix, arg1, arg2, arg3, arg4, path2) async{
  List<List> fileContents = await readFile(path2);
  final filename = 'entregaRetoFiltro.txt';

  String content = '';
  for (var i = 0; i < fileContents.length; i++) {
    content += multipleLinearRegression(matrix, fileContents[i][0], fileContents[i][1], fileContents[i][2], fileContents[i][3]) + '\n'; 
  }
  File(filename).writeAsString(content)
  .then((File file) {
    print('done!');
  });
}

String multipleLinearRegression(matrix, arg1, arg2, arg3, arg4) {
  String res;
  double r = 0, a, b1, b2, b3, b4;
  arg1 = double.parse(arg1);
  arg2 = double.parse(arg2);
  arg3 = double.parse(arg3);
  arg4 = double.parse(arg4);
  a = matrix[0][5];
  b1 = matrix[1][5];
  b2 = matrix[2][5];
  b3 = matrix[3][5];
  b4 = matrix[4][5];
  r = a + (b1 * arg1) + (b1 * arg1) + (b2 * arg2) + (b3 * arg3) + (b4 * arg4);
  res = r.toString();
  return res;
}

void gauss(matrix) {
  double temp;
  for(int i = 0; i < size; i++) {
    for (int j = i + 1; j < size; j++) {
      temp = matrix[j][i] / matrix[i][i];
      for(int k = i; k < size + 1; k++) {
        matrix[j][k] -= temp * matrix[i][k];
      }
    }
  }
  jordan(matrix);
}

void jordan(matrix) {
  double temp;
  for(int i = size - 1; i >= 0; i--) {
    for(int j = i - 1; j >= 0; j--) {
      temp = matrix[j][i] / matrix[i][i];
      for (int k = size; k >= i; k--) {
          matrix[j][k] -= temp * matrix[i][k];
      }
    }
  }
  List x = new List(size);
  for (int i = 0; i < size; i++) //making leading coefficients zero
    x[i] = 0;
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size + 1; j++) {
      if (x[i] == 0 && j != size)
        x[i] = matrix[i][j];
      if (x[i] != 0)
        matrix[i][j] /= x[i];
    }
  }
  //credits(matrix);
}

void credits(matrix) {
  for (int i = 0; i < size; i++) {
    print('x' + (i + 1).toString() + ' = ' + matrix[i][size].toString());
  }
}



main(List<String> arguments) {
  Future <List<List>> fileContents;
  print(arguments[0]);
  final stopwatch = Stopwatch()..start();
  constructMatrix(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5]);
  print('multipleLinearRegression executed in ${stopwatch.elapsed}');

}
