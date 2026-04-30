<%@ page import="java.util.*,com.vehiclerental.model.User" %>

<h2>User List</h2>

<table border="1">
<tr>
    <th>ID</th><th>Name</th><th>Email</th><th>Action</th>
</tr>

<%
List<User> users = (List<User>) request.getAttribute("users");

for (User u : users) {
%>
<tr>
    <td><%=u.getId()%></td>
    <td><%=u.getName()%></td>
    <td><%=u.getEmail()%></td>
    <td>
        <form method="post" action="users">
            <input type="hidden" name="id" value="<%=u.getId()%>"/>
            <input type="hidden" name="action" value="delete"/>
            <input type="submit" value="Delete"/>
        </form>
    </td>
</tr>
<% } %>
</table>

<a href="add-user.jsp">Add User</a>