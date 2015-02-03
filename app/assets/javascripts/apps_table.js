function drawTable(data, callback) {
  var columns = data.columns;
  var appData = data.app_data;
  var thDivs = $(columns).map(function() {
    return "<th>"+this.title+"</th>";
  }).get().join('');
  $("#table-placeholder").html("<table id='tbl' class='table stripe table-bordered' data-toggle='table'><tfoot>" + thDivs + "</tfoot></table>");
  var table = $('#tbl').dataTable({
    // dom:         'rtiS', // add scroller, remove 'f' at front to hide filtering element
    scrollY:     440,
    scrollCollapse: true,
    // paging: false,
    "deferRender": true, // for speed
    "order": [], // disable INITIAL sort order - for speed
    "sDom": 'T<"clear">lrtip', // remove 'filtering element' - see: https://datatables.net/reference/option/dom
    // "stateSave": true, // so user can navigate back to same view :)
    "data": appData,
    "columns": columns,
    // "columnDefs": [
    //   { "targets": [ 0 ], "visible": false, "searchable": false}, // hides 'order'
    //   { "targets": [ 9 ], "visible": false} // hides 'officer'
    // ],

    // "footerCallback": function(tfoot, data, start, end, display) {
    //   $('tfoot td').each( function (index, value) {
    //     $(this).html( '<input type="text" placeholder="'+columns[index].title+'" />' );
    //   });
    // }
    tableTools: {
      "sRowSelect": "multi",
      "aButtons": [
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
            oConfig.mColumns = [2];
            var sData = this.fnGetTableData(oConfig); // selected data
            alert(sData.length);
            var token = $('meta[name="csrf-token"]').attr("content");
            $('<form action="map" method="POST">' +
              '<input type="hidden" name="tableData" value="' + sData + '">' +
              '<input type="hidden" name="authenticity_token" value="' + token + '">' +
              '</form>').submit();
          }
        }
      ]
    }
  });

  // http://datatables.net/extensions/colvis/api
  var colvis = new $.fn.dataTable.ColVis( table );
  $( colvis.button() ).insertAfter('#tbl_length');

  $('.dataTables_scrollFoot tfoot th').each( function () { // remove '#tbl', add '.dataTbales_scrollFoot' for scroller
    var title = $('thead th').eq( $(this).index() ).text();  // remove '#tbl', add '.dataTables_scrollHead' for scroller
     $(this).html( '<input type="text" placeholder="'+title+'" />' );
  });

  // DataTable
  var table = $('#tbl').DataTable();
  // Apply the search
  table.columns().eq( 0 ).each( function ( colIdx ) {
    $('input', table.column( colIdx ).footer()).on( 'keyup change', function() {
      table
        .column( colIdx )
        .search( this.value )
        .draw();
    });
  });
  callback();
}
