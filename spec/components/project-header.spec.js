import m from 'mithril';
import projectHeader from '../../src/c/project-header';

describe('ProjectHeader', () => {
    let $output, projectDetail;

    describe('view', () => {
        beforeAll(() => {
            projectDetail = m.prop(ProjectDetailsMockery()[0]);
            let component = m.component(projectHeader, {
                    project: projectDetail,
                    userDetails: m.prop([])
                }),
                view = component.view(null, {
                    project: projectDetail,
                    userDetails: m.prop([])
                });
            $output = mq(view);
        });

        it('should a project header', () => {
            expect($output.find('#project-header').length).toEqual(1);
            expect($output.contains(projectDetail().name)).toEqual(true);
        });

        it('should render project-highlight / project-sidebar component area', () => {
            expect($output.find('.project-highlight').length).toEqual(1);
            expect($output.find('#project-sidebar').length).toEqual(1);
        });
    });
});
