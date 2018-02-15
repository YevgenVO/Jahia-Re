package fr.smile.yeost.ruls;

import fr.smile.jahia.service.JCRService;
import fr.smile.jahia.service.NodeService;
import org.jahia.services.content.JCRNodeWrapper;
import org.jahia.services.content.JCRPublicationService;
import org.jahia.services.content.JCRSessionFactory;
import org.jahia.services.content.JCRSessionWrapper;
import org.jahia.services.content.rules.AddedNodeFact;
import org.jahia.services.content.rules.PublishedNodeFact;
import org.jahia.services.usermanager.JahiaUserManagerService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.jcr.RepositoryException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

public class CreateJournalistUser {

    private JahiaUserManagerService userManagerService = JahiaUserManagerService.getInstance();

    private JCRPublicationService publicationService = JCRPublicationService.getInstance();

    private static final Logger LOG = LoggerFactory.getLogger(CreateJournalistUser.class);

    private JCRService jcrService;

    private NodeService nodeService;

    public void createUser(AddedNodeFact addedNodeFact) throws RepositoryException {
        JCRNodeWrapper journalist = addedNodeFact.getNode();
        JCRSessionWrapper defaultSession = JCRSessionFactory.getInstance().getCurrentSystemSession("default",
                null, null);
        Properties properties = nodeService.getNotInheritedProperties(journalist);
        JCRNodeWrapper userNode = userManagerService.createUser(journalist.getName(),
                properties.getProperty("password"), properties, defaultSession);

        journalist.setProperty("userUUID", userNode.getIdentifier());
        userNode.getSession().refresh(true);
        userNode.getSession().save();
        defaultSession.refresh(true);
        defaultSession.save();
        publicationService.publishByMainId(userNode.getIdentifier());
        publicationService.publishByMainId(journalist.getIdentifier());
        LOG.info("New journalist user with name '" + properties.get("name") + "' have been created.");
    }

    public void updateUser(PublishedNodeFact publishedNodeFact) throws RepositoryException {
        JCRNodeWrapper journalist = publishedNodeFact.getNode();
        JCRNodeWrapper  user;
        JCRSessionWrapper session = journalist.getSession();
        if (journalist.getPropertyAsString("userUUID") != null) {
            Map<String, String> conditionMap = new HashMap<>();
            conditionMap.put("[jcr:uuid]", journalist.getPropertyAsString("userUUID"));
            if (jcrService.getNodesWithCondition("jnt:user", session, conditionMap) != null) {
                user = (JCRNodeWrapper) jcrService.
                        getNodesWithCondition("jnt:user", session, conditionMap).next();
                List<String> nodeTypes = journalist.getNodeTypes();
                if (nodeTypes.contains("jmix:markedForDeletion")) {
                    deleteUser(user, session);
                } else {
                    nodeService.copyProperties(journalist, user);
                }
            } else {
                LOG.info("!!!!!!!!!!!!!!!! User related to journalist '" + journalist.getPropertyAsString("name") + "' can't be found.");
            }
        }
    }

    public boolean deleteUser(JCRNodeWrapper user, JCRSessionWrapper session) throws RepositoryException {
        String name = user.getPropertyAsString("Name");
        boolean returnValue = userManagerService.deleteUser(user.getPath(), session);
        session.refresh(true);
        session.save();
        LOG.info("User with name '" + name + "' have been deleted.");
        return returnValue;
    }

    public void setJahiaUserManagerService(JahiaUserManagerService userManagerService) {
        this.userManagerService = userManagerService;
    }

    public void setJcrService(JCRService jcrService) {
        this.jcrService = jcrService;
    }

    public void setNodeService(NodeService nodeService) {
        this.nodeService = nodeService;
    }
}
