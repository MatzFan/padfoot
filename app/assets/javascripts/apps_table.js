function drawTable(data, callback) {
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
      // "sSwfPath": "../flash/copy_csv_xls_pdf.swf",
      "sRowSelect": "multi",
      "aButtons": [
        'print',
        // 'copy',
        // 'xls',
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
          "sButtonText": "View on map",
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

  $('.dataTables_length').append(
    '<span>From date: <input type="text" id="from_date" class="datepicker"></span>' +
    '<span>To date: <input type="text" id="to_date" class="datepicker"></p></span>');
  $("#from_date").datepicker().datepicker("setDate", new Date(1988, 0, 1));
  $("#to_date").datepicker({ onClose: function(date) { alert(date); } }).datepicker("setDate", new Date()); // today

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
  callback();
}

