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
<c:set value="${param.orderBy}" var="orderBy"/>
<c:set value="${param.orderType}" var="orderType"/>

<jcr:sql var="judges" sql="select * from [yent:judge]"/>

<c:choose>
    <c:when test="${orderBy == null  || orderType eq null}">
        <jcr:sql var="judges" sql="select * from [yent:judge]"/>
    </c:when>
    <c:otherwise>
        <jcr:sql var="judges" sql="select * from [yent:judge] as j order by j.[${orderBy}] ${orderType}"/>
    </c:otherwise>
</c:choose>
<table>
    <tr>
        <th>
            <fmt:message key="name"/><br/>
            <a href="
                                <c:url value="${contentNode.url}judge.html">
                                    <c:param name="orderBy" value="name"/>
                                    <c:param name="orderType" value="asc"/>
                                </c:url>
                                "><span>&#8593;</span></a>
            <a href="
                                <c:url value="${contentNode.url}judge.html">
                                    <c:param name="orderBy" value="name"/>
                                    <c:param name="orderType" value="desc"/>
                                </c:url>
                                "><span>&#8595;</span></a>

        </th>
        <th><fmt:message key="surname"/></th>
        <th>
            <fmt:message key="year_in_office"/><br/>
            <a href="
                                <c:url value="${contentNode.url}judge.html">
                                    <c:param name="orderBy" value="yearInOffice"/>
                                    <c:param name="orderType" value="asc"/>
                                </c:url>
                                "><span>&#8593;</span></a>
            <a href="
                                <c:url value="${contentNode.url}judge.html">
                                    <c:param name="orderBy" value="yearInOffice"/>
                                    <c:param name="orderType" value="desc"/>
                                </c:url>
                                "><span>&#8595;</span></a>
        </th>
        <th><fmt:message key="year_of_registration"/></th>
        <th>
            <fmt:message key="canton"/><br/>
            <a href="
                                <c:url value="${contentNode.url}judge.html">
                                    <c:param name="orderBy" value="canton"/>
                                    <c:param name="orderType" value="asc"/>
                                </c:url>
                                "><span>&#8593;</span></a>
            <a href="
                                <c:url value="${contentNode.url}judge.html">
                                    <c:param name="orderBy" value="canton"/>
                                    <c:param name="orderType" value="desc"/>
                                </c:url>
                                "><span>&#8595;</span></a>
        </th>
        <th><fmt:message key="party"/></th>
        <th><fmt:message key="court"/></th>
        <th><fmt:message key="birth_death_date"/></th>
    </tr>
    <c:forEach var="judge" items="${judges.nodes}">
        <tr>
            <td>
                <a href="<c:url value="#" />"
                   onclick="window.open('${contentNode.url}judge/judge.html?id=${judge.identifier}', 'newwindow',
                           'width=800, height=400'); return false;" title="${judge.properties.name.string}">
                        ${judge.properties.name.string}</a>
            </td>

            <td>${judge.properties.surname.string}</td>
            <td>${judge.properties.yearInOffice.string}</td>
            <td>${judge.properties.yearOfRegistration.string}</td>
            <td>${judge.properties.canton.string}</td>
            <td>${judge.properties.parti.string}</td>
            <td>${judge.properties.court.string}</td>
            <fmt:formatDate var="birthDate" value="${judge.properties.birthDate.date.time}" pattern="yyyy"/>
            <fmt:formatDate var="deathDate" value="${judge.properties.deathDate.date.time}" pattern="yyyy"/>
            <td>
                    ${birthDate}-${deathDate}</td>
        </tr>
    </c:forEach>
</table>

<%--<c:choose>--%>
<%--<c:when test="${workspace.isLive}">--%>
<%--<c:set var="pageUrl" value="${url.live}"/>--%>
<%--</c:when>--%>
<%--</c:choose>--%>

<form action="${url.base}${currentNode.path}.ReverseJudgesNames.do" method="post"
      id="judges-names-revers">
    <input type="hidden" name="page" id="page" value="${fn:replace(url.live, url.baseLive, "")}"/>
    <%--<input type="hidden" name="page" id="page" value="${fn:replace(url.live, url.baseLive, "")}"/>--%>
    <button>Reverse Names</button>
</form>

<fmt:message key="yent_journalist.title.male"/>