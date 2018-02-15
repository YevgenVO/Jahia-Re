<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>

<h1>Judges</h1>
<jcr:sql var="res" sql="select * from [yent:judge] as j where j.[jcr:uuid]='${param.id}'"/>
<h2>${currentNode.properties['jcr:title'].string}</h2>

<c:forEach items="${res.nodes}" var="judge">
    <c:set var="name" value="${judge.properties['name'].string}"/>
    <c:set var="surname" value="${judge.properties['surname'].string}"/>
    <c:set var="yearInOffice" value="${judge.properties['yearInOffice'].decimal}"/>
    <c:set var="yearOfRegistration" value="${judge.properties['yearOfRegistration'].decimal}"/>
    <c:set var="canton" value="${judge.properties['canton'].string}"/>
    <c:set var="birthDate" value="${judge.properties['birthDate'].date}"/>
    <c:set var="court" value="${judge.properties['court'].string}"/>
    <c:set var="parti" value="${judge.properties['parti'].string}"/>
    <c:set var="deathDate" value="${judge.properties['deathDate'].date}"/>
    <c:set var="photo" value="${judge.properties['photo'].node}"/>
    <c:set var="biography" value="${judge.properties['biography'].string}"/>
    <c:set var="fullname" value="${name} ${surname}"/>
    <div class="judge_view">
        <table>
            <tr>
                <td>
                    <c:if test="${not empty photo.url}">
                        <img src="${photo.url}"/>
                    </c:if>
                </td>
                <td>
                    <h3>${fullname}</h3>
                    <p>${biography}</p>
                </td>
            </tr>
        </table>
    </div>
</c:forEach>
