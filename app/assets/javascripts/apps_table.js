function drawTable(data) {
  var columns = data.columns;
  var appData = data.app_data;
  var table = $('#tbl').dataTable({
    // "drawCallback": function() {
    //   $('#tbl').removeClass('loadable'); // ensures html rendered after table draw
    // },
    dom:         "frtiS", // add scroller
    scrollY:     440,
    scrollCollapse: true,
    // paging: false,
    "deferRender": true, // for speed
    "order": [], // disable INITIAL sort order
    "sDom": "lrtip", // remove 'filtering element' - see: https://datatables.net/reference/option/dom
    // "stateSave": true, // so user can navigate back to same view :)
    "data": appData,
    "columns": columns,
    "columnDefs": [
      { "targets": [ 0 ], "visible": false, "searchable": false}, // hides 'order'
      { "targets": [ 9 ], "visible": false} // hides 'officer'
    ]
  });
  // http://datatables.net/extensions/colvis/api
  var colvis = new $.fn.dataTable.ColVis( table );
  $( colvis.button() ).insertAfter('#table-controls');

  $('.dataTables_scrollFoot tfoot th').each( function () { // remove '#tbl', add '.dataTbales_scrollFoot' for scroller
    var title = $('.dataTables_scrollHead thead th').eq( $(this).index() ).text();  // remove '#tbl', add '.dataTables_scrollHead' for scroller
     $(this).html( '<input type="text" placeholder="'+title+'" />' );
  });
  // DataTable
  var table = $('#tbl').DataTable();
  // Apply the search
  table.columns().eq( 0 ).each( function ( colIdx ) {
    $( 'input', table.column( colIdx ).footer() ).on( 'keyup change', function () {
      table
        .column( colIdx )
        .search( this.value )
        .draw();
    });
  });
}
