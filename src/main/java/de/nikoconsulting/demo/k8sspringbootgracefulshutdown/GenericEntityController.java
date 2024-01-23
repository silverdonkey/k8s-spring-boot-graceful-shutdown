package de.nikoconsulting.demo.k8sspringbootgracefulshutdown;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.MediaType;

import java.util.ArrayList;
import java.util.List;

@RestController
@CrossOrigin(origins = "*")
public class GenericEntityController {

    Logger logger = LoggerFactory.getLogger(GenericEntityController.class);

    private List<GenericEntity> entityList = new ArrayList<>();

    {
        entityList.add(new GenericEntity(1L, "entity_1"));
        entityList.add(new GenericEntity(2L, "entity_2"));
        entityList.add(new GenericEntity(3L, "entity_3"));
        entityList.add(new GenericEntity(4L, "entity_4"));
    }

    @RequestMapping(value = "/entity/all", method = RequestMethod.GET, produces = {MediaType.APPLICATION_JSON_VALUE} )
    public List<GenericEntity> findAll() {
        // simulate slow response
        logger.info("Looking up entities for 5 seconds...");
        try {
            Thread.sleep(5000);
        } catch (InterruptedException e) {
            logger.error("Something went wrong while looking up for entities.", e);
        }
        logger.info("Returning found entities.");
        return entityList;
    }

    @RequestMapping(value = "/entity", method = RequestMethod.POST)
    public GenericEntity addEntity(GenericEntity entity) {
        logger.info("Adding a new entity: " + entity.getValue());
        entityList.add(entity);
        return entity;
    }

    @RequestMapping("/entity/findby/{id}")
    public GenericEntity findById(@PathVariable Long id) {
        logger.info("Looking up entity by id: " + id);
        return entityList.stream().
                filter(entity -> entity.getId().equals(id)).
                findFirst().get();
    }
}
