Execute Excel VBA Macro and update XLSM using SAS and Python


     WORKING CODE (Python)
        Hardpart was creating the xlsm (not shown)

        * input SAS dataset to update the xlsm;
        with SAS7BDAT('d:/sd1/class.sas7bdat') as m:;
        .   clas = m.to_data_frame();


         wb = load_workbook(filename='d:/xls/class_final.xlsm', read_only=False, keep_vba=True);
         ws = wb.get_sheet_by_name('class');
         rows = dataframe_to_rows(clas);

         * update the empty cells;
         for r_idx, row in enumerate(rows, 1):;
         .   for c_idx, value in enumerate(row, 1):;
         .        ws.cell(row=r_idx, column=c_idx, value=value);
         wb.save('d:/xls/class_final.xlsm');


see
https://goo.gl/cy2UC6
https://communities.sas.com/t5/Integration-with-Microsoft/Execute-Excel-VBA-Macro-using-SAS/m-p/372518

Excel macro will be executed when you open the workbook. Cheesey example.
We use Python for honor excel formatting and execute macro.

Template
https://www.dropbox.com/s/yiiamm8rs84eto0/classtemplate.xlsm?dl=0

Final updated template with computed total
https://www.dropbox.com/s/tokxyqz4p292z4h/class_final.xlsm?dl=0

  WORKING CODE
  ============

    1. Create empty xlsx template with all the formatting you
       want but with all cells blank. Formatting will be preserved when you update.
       Minimal formatting in this example.

      libname xel "d:/xls/classtemplate.xlsx";
      data xel.class;
        set sashelp.class;
        call missing(of _all_);
      run;quit;
      proc sql;
        drop table xel.class
      ;quit;
      libname xel clear;

    2. Open the excel template workbook "d:/xls/classtemplate.xlsx"
       you just created an insert this vba macro.

       Sub sum_weight()
           Range("F21").Select
           ActiveCell.FormulaR1C1 = "=SUM(R[-19]C:R[-1]C)"
           Range("F22").Select
       End Sub

    3. Save as macro enabled workbook "d:/xls/classtemplate.XLSM" (note XLSM);

    4. Copy template to "d:/xls/class_final.XLSM".
       You want to save the template for other updates?

       %bincop(in=d:/xls/classtemplate.xlsm,out=d:/xls/class_final.xlsm);

    5. Run the python code below to populate the sheet keeping all formatting.
       Note the option -- keep_vba=True

       wb = load_workbook(filename='d:/xls/class_final.xlsm', read_only=False, keep_vba=True);
       ws = wb.get_sheet_by_name('class');
       rows = dataframe_to_rows(clas);
       for r_idx, row in enumerate(rows, 1):;
       .   for c_idx, value in enumerate(row, 1):;
       .        ws.cell(row=r_idx, column=c_idx, value=value);
       wb.save('d:/xls/class_final.xlsm');

    6. When you open the workbook the VBA macro will automatiacally
       be executed, showing the total of column weight.




Win 7 64bit
Excel 2010 64bit
SAS 64bit
Pythin 2.7 - openpyxl 2.4

I think only Python can do this? Not SAS, R or Perl?
Recent WPS has an interface to Python can do this.  I don't have it.


HAVE create macro enabled excel 2010 64bit  workbook d:/xls/classtemplate.xlsm
==================================================================

     Start by creating an XLSX template. Only one empty sheet(class) in
    "d:/xls/classtemplate.xlsx"

      %utlfkil(d:/xls/classtemplate.xlsx); * delete if exist;
      libname xel "d:/xls/classtemplate.xlsx";
      data xel.class;
        set sashelp.class;
        call missing(of _all_);
      run;quit;
      proc sql;
        drop table xel.class
      ;quit;
      libname xel clear;

      * manually add this VBA macro;

      Sub sum_weight()
          Range("F21").Select
          ActiveCell.FormulaR1C1 = "=SUM(R[-19]C:R[-1]C)"
          Range("F22").Select
      End Sub

      Save as macro enabled workbook "d:/xls/classtemplate.XLSM".
      This is what the macro enabled workshhet class should look like.


         +----------------------------------------------------------------+
         |     A      |     B      |    C       |    C       |   ...      |
         -----------------------------------------------------------------+
      1  |            |            |            |            |            |
         +------------+------------+------------+------------+------------+
      2  |            |            |            |            |            |
         +------------+------------+------------+------------+------------+
          ...
         +------------+------------+------------+------------+------------+
      20 |   ...      |   ...      |   ...      |   ...      |    ...     |
         +------------+------------+------------+------------+------------+

       [CLASS]

       * make a copy of the macro enabled workbook to update;
       * generally you do not wabt to destroy your template;

       %bincop(in=d:/xls/classtemplate.xlsm,out=d:/xls/class_final.xlsm);



WANT  update sheet class with sashelp.class
===========================================

        +----------------------------------------------------------------+
        |     A      |    B       |     C      |    D       |    E       |
        +----------------------------------------------------------------+
     1  | NAME       |   SEX      |    AGE     |  HEIGHT    |  WEIGHT    |
        +------------+------------+------------+------------+------------+
     2  | ALFRED     |    M       |    14      |    69      |  112.5     |
        +------------+------------+------------+------------+------------+
         ...
        +------------+------------+------------+------------+------------+
     20 | WILLIAM    |    M       |    15      |   66.5     |  112       |
        +------------+------------+------------+------------+------------+
     21 |            |            |            |            |  1900.9    | Macro supplied total
        +------------+------------+------------+------------+------------+ on opening workbook

      [CLASS]
*                _          _                       _       _
 _ __ ___   __ _| | _____  | |_ ___ _ __ ___  _ __ | | __ _| |_ ___
| '_ ` _ \ / _` | |/ / _ \ | __/ _ \ '_ ` _ \| '_ \| |/ _` | __/ _ \
| | | | | | (_| |   <  __/ | ||  __/ | | | | | |_) | | (_| | ||  __/
|_| |_| |_|\__,_|_|\_\___|  \__\___|_| |_| |_| .__/|_|\__,_|\__\___|
;

%utlfkil(d:/xls/classtemplate.xlsx); * delete if exist;
libname xel "d:/xls/classtemplate.xlsx";
data xel.class;
  set sashelp.class;
run;quit;
proc sql;
  drop table xel.class
;quit;
libname xel clear;

* manually add this VBA macro;
/*
Sub sum_weight()
    Range("F21").Select
    ActiveCell.FormulaR1C1 = "=SUM(R[-19]C:R[-1]C)"
    Range("F22").Select
End Sub
*/

*Manually Save as macro enabled workbook;

* make a coy of template;
%bincop(in=d:/xls/classtemplate.xlsm,out=d:/xls/class_final.xlsm);

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|
;

* create SAS data to update template;
options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.class;
  set sashelp.class;
run;quit;

*                _       _             _               _
 _   _ _ __   __| | __ _| |_ ___   ___| |__   ___  ___| |_
| | | | '_ \ / _` |/ _` | __/ _ \ / __| '_ \ / _ \/ _ \ __|
| |_| | |_) | (_| | (_| | ||  __/ \__ \ | | |  __/  __/ |_
 \__,_| .__/ \__,_|\__,_|\__\___| |___/_| |_|\___|\___|\__|
      |_|
;
 _ __  _   _| |_| |__   ___  _ __
| '_ \| | | | __| '_ \ / _ \| '_ \
| |_) | |_| | |_| | | | (_) | | | |
| .__/ \__, |\__|_| |_|\___/|_| |_|
|_|    |___/
;

%utl_submit_py64("
from openpyxl.utils.dataframe import dataframe_to_rows;
from openpyxl import Workbook;
from openpyxl import load_workbook;
from sas7bdat import SAS7BDAT;
with SAS7BDAT('d:/sd1/class.sas7bdat') as m:;
.   clas = m.to_data_frame();
print(clas);
wb = load_workbook(filename='d:/xls/class_final.xlsm', read_only=False, keep_vba=True);
ws = wb.get_sheet_by_name('class');
rows = dataframe_to_rows(clas);
for r_idx, row in enumerate(rows, 1):;
.   for c_idx, value in enumerate(row, 1):;
.        ws.cell(row=r_idx, column=c_idx, value=value);
wb.save('d:/xls/class_final.xlsm');
");
