package fr.smile.yeost.action;

import fr.smile.jahia.service.JCRService;
import org.jahia.bin.Action;
import org.jahia.bin.ActionResult;
import org.jahia.services.content.JCRNodeIteratorWrapper;
import org.jahia.services.content.JCRSessionWrapper;
import org.jahia.services.render.RenderContext;
import org.jahia.services.render.Resource;
import org.jahia.services.render.URLResolver;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.jcr.Node;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;


public class ReverseJudgesNames extends Action {
    private JCRService jcrService;

    private static final Logger LOG = LoggerFactory.getLogger(ReverseJudgesNames.class);

    @Override
    public ActionResult doExecute(HttpServletRequest httpServletRequest, RenderContext renderContext, Resource resource, JCRSessionWrapper jcrSessionWrapper, Map<String, List<String>> map, URLResolver urlResolver) throws Exception {
//        JCRService jcrService = new JCRService();
        LOG.info("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Inside doExecute!");
        for ( Node node: jcrService.getNodes("yent:judge", jcrSessionWrapper)) {
            String name = node.getProperty("name").getString();
            node.setProperty("name", node.getProperty("surname").getString());
            node.setProperty("surname", name);

        }
        jcrSessionWrapper.save();

        return new ActionResult(HttpServletResponse.SC_OK, httpServletRequest.getParameter("page")
                .replaceAll(".html", ""));
    }

    public void setJcrService(JCRService jcrService) {
        this.jcrService = jcrService;
    }
}
