<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.incapp.dao.DAO"%>
<%
	String uemail=(String)session.getAttribute("uemail");
	if(uemail==null) {
		session.setAttribute("msg", "Please Login first!");
		response.sendRedirect("UserLogin.jsp");
	}else {
		DAO db=new DAO();
		HashMap user=db.getUserByEmail(uemail);
		ArrayList<HashMap> orders=db.getOrdersByEmail(uemail);
		int cartQty=db.getCartQty(uemail);
		db.closeDBConnection();
%>
<!DOCTYPE html>
<html>
<head>
  <title>MediSol</title>
  <link rel="icon" href="resources/medisol.png" />

  <meta name="viewport" content="width=device-width, initial-scale=1">

  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.1/jquery.min.js" integrity="sha512-aVKKRRi/Q/YV+4mjoKBsE4x3H+BkegoM/em46NNlCqNTmUYADjBbeNefNxYV7giUp0VxICtqdrbqU7iVaeZNXA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/4.6.2/js/bootstrap.min.js" integrity="sha512-7rusk8kGPFynZWu26OKbTeI+QPoYchtxsmPeBqkHIEXJxeun4yJ4ISYe7C6sz9wdxeE1Gk3VxsIWgCZTc+vX3g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/4.6.2/css/bootstrap.min.css" integrity="sha512-rt/SrQ4UNIaGfDyEXZtNcyWvQeOq0QLygHluFQcSjaGB04IxWhal71tKuzP6K8eYXYB6vJV4pHkXcmFGGQ1/0w==" crossorigin="anonymous" referrerpolicy="no-referrer" />

  <!-- font awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css" integrity="sha512-xh6O/CkQoPOWDdYTDqeRdPCVd1SpvCA9XXcUnZS2FmJNp1coAFzvtCN9BmamE+4aHK8yyUHUSCcJHgXloTyT2A==" crossorigin="anonymous" referrerpolicy="no-referrer" />
  <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/js/all.min.js" integrity="sha512-naukR7I+Nk6gp7p5TMA4ycgfxaZBJ7MO5iC3Fp6ySQyKFHOGfpkSZkYVWV5R7u7cfAicxanwYQ5D1e17EfJcMA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
  
  <!-- Lightbox CSS & Script -->
  <script src="resources/lightbox/ekko-lightbox.js"></script>
  <link rel="stylesheet" href="resources/lightbox/ekko-lightbox.css"/>
  <!-- Lightbox END -->

  <!-- AOS CSS & Script -->
  <script src="resources/aos/aos.js"></script>
  <link rel="stylesheet" href="resources/aos/aos.css"/>
  <!-- AOS END -->

  <!-- custom css -->
  <link rel="stylesheet" href="resources/custom.css">

</head>
<body>
	<%
		String m=(String)session.getAttribute("msg");
		if(m!=null){
			if(m.contains("success")){
			%>
				<h6 class="bg-success text-white text-center p-3"><%=m %></h6>
			<% 
				session.setAttribute("msg", null);
			}else if(m.contains("failed") || m.contains("Already")){
			%>
				<h6 class="bg-danger text-white text-center p-3"><%=m %></h6>
			<% 
				session.setAttribute("msg", null);
			}else {
			%>
				<h6 class="bg-warning text-center p-3"><%=m %></h6>
			<% 
				session.setAttribute("msg", null);
			}
		}
	%>
  <nav class="navbar navbar-expand-sm container">
      <a class="navbar-brand" href="UserHome.jsp">
        <img src="resources/medisol.png" alt=""/> <span>Medi</span>Sol
      </a>
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#my-navbar"><i class="fa-solid fa-bars"></i></button>
      <div class="collapse navbar-collapse" id="my-navbar">
          <ul class="navbar-nav  mx-auto">
            <li>
              <a class="nav-link" href="UserHome.jsp">Home</a>
            </li>
            <li>
              <a class="nav-link" href="UserOrders.jsp">Orders</a>
            </li>
          </ul>
          <p>
          Welcome: <b><%=user.get("name")%></b>  
          <a class="btn btn-sm btn-warning m-2" href="Cart.jsp">Cart[<%=cartQty %>]</a>
          <a class="btn btn-sm btn-danger m-2" href="Logout">Logout</a>
          </p>
          
      </div>
  </nav>
  
  <section class="container-fluid bg-info mt-4 p-4">
  	<h4 class="text-center">Your Orders:</h4>
  	<%
  	for(HashMap order:orders) {
  	%>
  		<div class="bg-light p-4 m-3">
  			<h6>
  				Order ID: <big><%=order.get("id") %></big> &nbsp;&nbsp;&nbsp;&nbsp;
  				Date: <big><%=order.get("odate") %></big> &nbsp;&nbsp;&nbsp;&nbsp;
  				Amount: <big><%=order.get("amount") %></big> &nbsp;&nbsp;&nbsp;&nbsp;
  				Status: <big><%=order.get("status") %></big> 
  				<%
  				String status=(String)order.get("status");
  				if(status.equalsIgnoreCase("Placed") || status.equalsIgnoreCase("Confirmed")){
  					%>
  						&nbsp;&nbsp;&nbsp;&nbsp;
  						<a class="btn btn-sm btn-danger" href="ChangeOrderStatus?id=<%=order.get("id") %>&status=Cancel&page=UserOrders">Cancel Order</a>
  					<%
  				}
  				%>
  			</h6>
  			<hr>
  			<%
				String items=(String)order.get("items");
				items=items.substring(0, items.length()-1);
				String i[]=items.split(",");
				for(String item:i){
					String ii[]=item.split(":");
			%>
				<p>
	  				<img height="30px" src="GetImage?name=<%=ii[0]%>"> &nbsp;&nbsp;
	  				<%=ii[0] %> &nbsp;&nbsp; Price: <b><%=ii[1] %></b>
	  			</p>
			<%		
				}
			%>
  			<p>
  				Address: <b><%=order.get("address") %></b>
  			</p>
  		</div>	
  	<%
  	}
  	%>
  </section>
  <footer class="container m-5">
    <div class="row">
      <div class="col-sm m-2 text-left">
        <img src="resources/medisol.png" height="20px" alt=""/> <span class="text-danger"><b>Medi</b></span>Sol
        <p>
          Lorem ipsum dolor sit amet consectetur.
          <br>
          Lorem ipsum dolor sit amet consectetur adipisicing elit.
        </p>
      </div>
      <div class="col-sm m-2 text-right">
        <p>
          <a class="m-2" href="http://www.facebook.com/incapp" target="_blank"><i class="fa-brands fa-facebook-f fa-2x"></i></a>
          <a class="m-2" href="http://www.instagram.com/incapp.in" target="_blank"><i class="fa-brands fa-instagram fa-2x"></i></a>
          <a class="m-2" href="http://www.youtube.com/incapp" target="_blank"><i class="fa-brands fa-youtube fa-2x"></i></a>
        </p>
      </div>
    </div>
  </footer>
  <a id="btnTop"><i class="fa-solid fa-circle-up fa-2x"></i></a>
  
</body>
<script>
  //AOS
  AOS.init();

  //script for scroll to top
  $("#btnTop").click(function () {
        $("html, body").animate({scrollTop: 0}, 1000);
    });
  //script for scroll to Service Section
  $("#service-menu").click(function () {
      document.getElementById("service").scrollIntoView({behavior: 'smooth'});
    });
  //script for light box
  $(document).on('click', '[data-toggle="lightbox"]', function(event) {
      event.preventDefault();
      $(this).ekkoLightbox();
  });

</script>
</html>
<%
}
%>