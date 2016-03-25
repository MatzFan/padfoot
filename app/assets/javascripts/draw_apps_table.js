function drawAppsTable(data, callback) {
  var columns = data.columns;
  var appData = data.app_data;
  var thDivs = $(columns).map(function() {
    return "<th>"+this.title+"</th>";
  }).get().join('');
  $("#table-placeholder").html("<table id='tbl' class='table stripe table-bordered' data-toggle='table'><tfoot>" + thDivs + "</tfoot></table>");
  var table = $('#tbl').dataTable({
    // dom:         'rtiS', // add scroller, remove 'f' at front to hide filtering element
    scrollY:     530, // pixels
    scrollCollapse: true,
    // paging: false,
    "deferRender": true, // for speed
    "order": [], // disable INITIAL sort order - for speed
    "sDom": 'T<"clear">lrtip', // remove 'filtering element' - see: https://datatables.net/reference/option/dom
    "stateSave": true, // so user can navigate back to same view :)
    "search": {"smart": false}, // disable smart search
    "data": appData,
    "columns": columns,
    // "columnDefs": [
    //   { "targets": [ 0 ], "visible": false, "searchable": false}, // hides 'order'
    //   { "targets": [ 9 ], "visible": false} // hides 'officer'
    // ],


    initComplete: function() { // dropdown list for column rows defined in indexArray
      var api = this.api();
      var indexArray = [3,4,10,11,12]; // HARD CODED HERE
      $.each(indexArray, function (i, index) {
        var column = api.column(index);
        var title = $(column.header()).text();
        var select = $('<select><option value=""></option></select>')
        .appendTo( $(column.footer()).empty() )
        .on( 'change', function () {
          var val = $.fn.dataTable.util.escapeRegex($(this).val());

          if(val.substring(0,5) === '<div>') {
            val = val.substring(5, (val.length - 7)); // removes <div>...<\/div> tags..
          }

          if(val === 'null') {
            column.search('^$', true, false).draw();
          } else {
            if(title === 'Constraints') {
              column.search( val ? '(' +val+ ')' : '', true, false ).draw(); // search across all lines for constraints
            } else {
              column.search( val ? '^(' +val+ ')$' : '', true, false ).draw();
            }
          }
        });
        var dataList = column.data(); // may contain nulls
        if(title === 'Constraints' || title === 'Meetings') {
          dataList = dataList.map(function(element) {
            if(element) { // check for nulls (no constraints)
              return $(element.split('<br/>').join(',')).text().split(','); // replace <br/> with , then extract text before splitting..
            } else {
              return null
            }
          }).flatten();
        }
        dataList.unique().sort().each( function ( d, j ) {
          select.append( '<option value="'+d+'">'+d+'</option>' )
        });
      });
    }, // end of initComplete hook


    tableTools: {
      "sSwfPath": "http://cdn.datatables.net/tabletools/2.2.3/swf/copy_csv_xls_pdf.swf",
      "sRowSelect": "multi",
      "aButtons": [
        { "sExtends": "copy", "bFooter": false, "mColumns": "visible", "bSelectedOnly": true, "sToolTip": "Copy selected rows" },
        { "sExtends": "csv", "bFooter": false, "mColumns": "visible", "bSelectedOnly": true, "sToolTip": "Export selected rows as csv (Excel compatible)" },
        { "sExtends": "pdf", "bFooter": false, "mColumns": "visible", "bSelectedOnly": true, "sPdfOrientation": "landscape", "sToolTip": "Save selected rows as pdf" },
        { "sExtends": "print", "bFooter": false, "mColumns": "visible", "bSelectedOnly": true },
        "select_none",
        {
          "sExtends": "select_all",
          "sButtonText": "Select all",
          "fnClick": function (nButton, oConfig, oFlash) {
            var oTT = TableTools.fnGetInstance('tbl');
            oTT.fnSelectAll(true); //True = Select only filtered rows (true). Optional - default false.
          }
        },
        {
          "sExtends": "text",
          "sButtonText": "Clear all filters",
          "fnClick": function ( nButton, oConfig, oFlash ) { clearTableState(); }
        },
        {
          "sExtends": "text",
          "sButtonText": "View on map",
          "sToolTip": "Click to select one or more rows, or 'Select all'",
          "fnClick": function ( nButton, oConfig, oFlash ) {
            oConfig.bHeader = false;
            oConfig.mColumns = [2]; // refs column only - FRAGILE
            var token = $('meta[name="csrf-token"]').attr("content");
            var sData = this.fnGetTableData(oConfig); // selected data
            var numSelected = TableTools.fnGetInstance('tbl').fnGetSelected().length;
            if(numSelected == 0) { // ALL 30,000 are plotted without this guard!!!!!!!
              alert("Select one or more applications by clicking on the row(s), or use 'Select all'.");
            } else {
              if(confirm(numSelected + " applications selected, do you want to plot these?") == true){
                $('<form action="map" method="POST">' +
                '<input type="hidden" name="tableData" value="' + sData + '">' +
                '<input type="hidden" name="authenticity_token" value="' + token + '">' +
                '</form>').submit();
              }
            }
          }
        }
      ],
    } // end of tableTools
  }); // end of dataTable init

  var colvis = new $.fn.dataTable.ColVis( table ); // http://datatables.net/extensions/colvis/api
  $( colvis.button() ).insertAfter('#tbl_length');

  $('.dataTables_scrollFoot tfoot th').each( function () {
    var title = $('thead th').eq( $(this).index() ).text();
    var lovs = ['Code', 'Status', 'Parish', 'Constraints', 'Meetings'] // HARD CODED HERE
    if($.inArray(title, lovs) === -1){
      $(this).html( '<input type="text" placeholder="'+title+'" />' );
    }
  });

  var table = $('#tbl').DataTable();
  table.columns().eq(0).each(function(colIdx) {
    $('input', table.column(colIdx).footer()).on('keyup change', function() {
      table
        .column(colIdx)
        .search(this.value)
        .draw();
    });
  });
  setupDatePickers();
  addDateRangeFilter();
  callback();
  table.draw(); // draw after date range filter added
} // end of drawTable()

function clearTableState() {
  var table = $('#tbl').DataTable();
  table.state.clear();
  window.location.reload();
}

function addDateRangeFilter() {
  $.fn.dataTableExt.afnFiltering.push(
    function(oSettings, aData, iDataIndex) {
      var iFini = document.getElementById('from_date').value;
      var iFfin = document.getElementById('to_date').value;
      var iDateCol = 1;
      iFini = iFini.substring(6,10) + iFini.substring(3,5)+ iFini.substring(0,2);
      iFfin = iFfin.substring(6,10) + iFfin.substring(3,5)+ iFfin.substring(0,2);
      var date = aData[iDateCol].substring(0,4) + aData[iDateCol].substring(5,7)+ aData[iDateCol].substring(8,10);
      if ( iFini === "" && iFfin === "" ) { return true; }
      else if ( iFini <= date && iFfin === "") { return true; }
      else if ( iFfin >= date && iFini === "") { return true; }
      else if (iFini <= date && iFfin >= date) { return true; }
      return false;
    }
  );
}

function setupDatePickers() {
  var table = $('#tbl').DataTable();
  $('.dataTables_length').append('<span style="margin-left:20px">'+
    'From: <input type="text" id="from_date" class="datepicker" size="10"><span style="margin-left:20px">'+
    'To: <input type="text" id="to_date" class="datepicker" size="10"></span></span>');
  var fromDatePicker = $("#from_date").datepicker({
    dateFormat: 'dd/mm/yy',
    changeYear: true,
    yearRange: "1984:2015",
    onSelect: function() { table.draw(); }
  })
  fromDatePicker.datepicker("setDate", new Date(2006, 5, 1)); // defaults to 1 June 2006

  var toDatePicker = $("#to_date").datepicker({
    dateFormat: 'dd/mm/yy',
    changeYear: true,
    yearRange: "1984:2015",
    onSelect: function() { table.draw(); }
  })
  toDatePicker.datepicker("setDate", new Date()); // today
}
