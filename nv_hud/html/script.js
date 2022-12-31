$(function() {

    function display(bool) {
        if (bool) {
            $("#container").show();
        } else {
            $("#container").hide();
        }
    }
    display(true)
    $("#society-container").hide();


    function moneyFormat(x) {
        return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
    }

    window.addEventListener('message', function(event) {
        if (event.data.type === "ui") {
            if (event.data.status == true) {
                display(true)
            } else {
                display(false)
            }
        } else if (event.data.type === "update") {
            var date = new Date();
            document.getElementById("date").innerHTML = ("0" + date.getHours()).slice(-2) + '</span><span style="color:#7cc576">' + ":" + '</span><span style="color:white">' + ("0" + date.getMinutes()).slice(-2);
            document.getElementById("id").innerHTML = "ID:" + '</span><span style="color:#7cc576">' + event.data.id;
            document.getElementById("health").style.width = event.data.health + "%";
            document.getElementById("armor").style.width = event.data.armor + "%";
            // document.getElementById("stamina").style.width = event.data.stamina + "%";
            document.getElementById("hunger").style.width = event.data.food + "%";
            document.getElementById("thirst").style.width = event.data.water + "%";
            // document.getElementById("job").innerHTML = event.data.job;
            document.getElementById("cash").innerHTML = '<span style="color:white">' + '0'.repeat(12 - event.data.cash.toString().length) + '</span><span style="color:#45ac44">' + event.data.cash + '</span><span style="color: white ">$</span>';


            // document.getElementById("society").innerHTML = '<span style="color:white">' + '0'.repeat(12 - event.data.socBal.toString().length) + '</span><span style="color:#7cc576">' + event.data.socBal + '</span><span style="color:white">$</span>';
        } else if (event.data.type === "isBoss") {
            if (event.data.isBoss == true) {
                $("#society-container").show();
            } else {
                $("#society-container").hide();
            }
        }
    })
})

function show(bool) {
    if (bool) {
        $('#editor').show();
    } else {
        $('#editor').hide();
    };
};

show(false);

document.onkeyup = function(data) {
    if (data.which == 27) {
        let directory = GetParentResourceName()
        $.post('https://' + directory + '/exit', JSON.stringify({}));
        return;
    };
};